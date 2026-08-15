# frozen_string_literal: true

class BillsController < ApplicationController
  SEARCH_LIMIT = 50
  before_action :set_bill, only: %i[show edit update destroy]

  # GET /bills or /bills.json
  def index
    @bills = Bill.all
    @congress = params[:congress].presence
    @bill_type = params[:bill_type].presence

    if @bill_type && @congress.nil?
      flash.now[:alert] = 'Searching by bill type requires a congress session number.'
      return
    end

    @search_results = congress_api_bills
  end

  # GET /bills/1 or /bills/1.json
  def show; end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit; end

  # POST /bills or /bills.json
  def create
    @bill = Bill.new(bill_params)
    @bill.summary = fetch_bill_summary(@bill) if @bill.summary.blank?

    respond_to do |format|
      if @bill.save
        format.html { redirect_to @bill, notice: 'Bill was successfully created.' }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.', status: :see_other }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1 or /bills/1.json
  def destroy
    @bill.destroy!

    respond_to do |format|
      format.html { redirect_to bills_path, notice: 'Bill was successfully destroyed.', status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bill
    @bill = Bill.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bill_params
    params.require(:bill).permit(:title, :congress, :number, :original_chamber, :type, :summary)
  end

  def congress_api_bills
    Congress::Client.new(congress_api_key)
                    .bills(congress: @congress, type: @bill_type, limit: SEARCH_LIMIT)
                    .get
  rescue ArgumentError, Congress::Error, Faraday::Error => e
    flash.now[:alert] = "Could not reach the congress.gov API: #{e.message}"
    nil
  end

  def congress_api_key
    ENV.fetch('CONGRESS_GOV_API_KEY', Rails.application.credentials[:CONGRESS_GOV_API_KEY])
  end

  def fetch_bill_summary(bill)
    return nil if bill.congress.blank? || bill.type.blank? || bill.number.blank?

    client = Congress::Client.new(congress_api_key)
    response = client.summaries(congress: bill.congress, bill_type: bill.type, bill_number: bill.number).get
    latest_summary_text(response)
  rescue ArgumentError, Congress::Error, Faraday::Error
    nil
  end

  def latest_summary_text(response)
    summaries = response['summaries']
    return nil if summaries.blank?

    latest = summaries.max_by { |summary| summary['actionDate'].to_s }
    helpers.strip_tags(latest['text']).squish.presence
  end
end
