module BillsHelper
  def bill_number_label(bill)
    "#{bill['type']} #{bill['number']}"
  end

  def bill_number_label_for_record(bill)
    "#{bill.bill_type.upcase} #{bill.number}"
  end

  def bill_last_action(bill)
    action = bill['latestAction']
    return 'No action recorded' if action.blank?

    date = format_action_date(action['actionDate'])
    text = action['text'].to_s.sub(/\.\s*\z/, '')
    "#{text} on #{date}"
  end

  private

  def format_action_date(raw_date)
    Date.parse(raw_date.to_s).strftime('%b %-d, %Y')
  rescue ArgumentError, TypeError
    raw_date.to_s
  end
end