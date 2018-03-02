class Order < ApplicationRecord
  belongs_to :user
  belongs_to :member
  after_update :save_sales
  after_create :save_costs
  
  def as_json(options={})
        super.as_json(options).merge({user_name: get_user_name}).merge({starttime: formatted_starttime, endtime: formatted_endtime })
      end

    def get_user_name
      self.member && self.member.name
    end
    
    def formatted_starttime
      unless self.starttime == nil
        self.starttime.strftime('%a %b %d %H:%M:%S %Z %Y')
      end
    end
    def formatted_endtime
      unless self.endtime == nil
        self.endtime.strftime('%a %b %d %H:%M:%S %Z %Y')
      end
    end
    
    def save_sales
      unless self.endtime == nil
        Account.first.update(sales: Account.first.sales + self.amount)
      end
    end
    
    def save_costs
      Account.first.update(costs: Account.first.costs + self.cost)
    end
    
end
