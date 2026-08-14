# == Schema Information
#
# Table name: bills
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Bill < ApplicationRecord
  TYPES = {
    'hr'      => 'H.R. — House Bill',
    's'       => 'S. — Senate Bill',
    'hres'    => 'H.Res. — House Simple Resolution',
    'sres'    => 'S.Res. — Senate Simple Resolution',
    'hjres'   => 'H.J.Res. — House Joint Resolution',
    'sjres'   => 'S.J.Res. — Senate Joint Resolution',
    'hconres' => 'H.Con.Res. — House Concurrent Resolution',
    'sconres' => 'S.Con.Res. — Senate Concurrent Resolution'
  }.freeze

  def self.bill_types
    TYPES
  end
end
