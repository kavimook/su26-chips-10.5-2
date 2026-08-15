# frozen_string_literal: true

module BillsHelper
  # congress.gov returns full type codes ('HR', 'SRES', 'HJRES'...). The assignment
  # wants a shorthand prefix -- 'HR 123', 'SR 999'. Note 'SR' is not itself a
  # congress.gov code; it reads as shorthand for a Senate resolution (SRES).
  # Anything unmapped falls back to the code upcased.
  TYPE_SHORTHAND = {
    'hr' => 'HR',
    's' => 'S',
    'hjres' => 'HJR',
    'sjres' => 'SJR',
    'hconres' => 'HCR',
    'sconres' => 'SCR',
    'hres' => 'HRES',
    'sres' => 'SR'
  }.freeze

  # 'HR 3076' / 'SR 999'
  def bill_number_label(api_bill)
    type = api_bill['type'].to_s.downcase
    "#{TYPE_SHORTHAND.fetch(type, type.upcase)} #{api_bill['number']}"
  end

  # 'HR 3076' for a Bill record saved in our own database.
  def saved_bill_number_label(bill)
    bill_number_label('type' => bill.type, 'number' => bill.number)
  end

  # 'Became Public Law No: 117-108 on Apr 6, 2024'
  def bill_last_action(api_bill)
    action = api_bill['latestAction']
    return '' if action.blank?

    date = safe_parse_date(action['actionDate'])
    return action['text'].to_s if date.nil?

    "#{action['text']} on #{date.strftime('%b %-d, %Y')}"
  end

  # Params for the Save button. congress.gov reports 'HR' and 'House'; the Bill
  # model validates against lowercase codes, so both must be downcased here.
  def bill_save_params(api_bill)
    {
      bill: {
        title: api_bill['title'],
        congress: api_bill['congress'],
        number: api_bill['number'],
        original_chamber: api_bill['originChamber'].to_s.downcase,
        type: api_bill['type'].to_s.downcase
      }
    }
  end

  private

  def safe_parse_date(value)
    Date.parse(value.to_s)
  rescue Date::Error
    nil
  end
end
