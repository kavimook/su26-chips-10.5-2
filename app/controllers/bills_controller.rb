# frozen_string_literal: true

class BillsController < ApplicationController
  before_action :set_bill, only: %i[show edit update destroy]

  RESULTS_LIMIT = 50

  # GET /bills or /bills.json
  def index
    @bills = Bill.all
    @congress = params[:congress].presence
    @type = params[:type].presence

    if @type.present? && @congress.blank?
      flash.now[:alert] = 'Please provide a Congress number to search by bill type.'
      @search_results = []
      return
    end

    @search_results = fetch_search_results
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

  def fetch_search_results
    response = if @congress.present?
                 congress_client.bills(congress: @congress, type: @type || 'all', limit: RESULTS_LIMIT).get
               else
                 congress_client.recent_bills(limit: RESULTS_LIMIT).get
               end
    Array(response['bills'])
  rescue Congress::Error => e
    flash.now[:alert] = "Could not reach Congress.gov: #{e.message}"
    []
  end

  def congress_client
    @congress_client ||= Congress::Client.new(Rails.application.credentials[:CONGRESS_GOV_API_KEY])
  end
end
