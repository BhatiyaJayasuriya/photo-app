class Payment < ActiveRecord::Base
  
  attr_accessor :card_number, :card_cvv, :card_expires_month, :card_expires_year
  # attributes (params) from form will not be persisted to the db, there for we are using
  # only the getter and setters 
  belongs_to :user
  
  def self.month_options
    Date::MONTHNAMES.compact.each_with_index.map { |name, i| ["#{i+1} - #{name}", i+1] }
	                # (compact will remove nil items from MONTHNAMES array)
	  # Date::MONTHNAMES.compact.each_with_index.map do |name, i|
      # "#{i+1} - #{name}"                                                                                  
      # i+1
    # end
  end
  
  def self.year_options
    (Date.today.year..(Date.today.year+10)).to_a
  end
  
  def process_payment
    customer = Stripe::Customer.create email: email, card: token

    Stripe::Charge.create customer: customer.id,
                          amount: 1000, # $10 in cents
	                        description: 'Premium',
                          currency: 'usd'
  end
  
end
