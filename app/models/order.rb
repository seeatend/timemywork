class Order < ApplicationRecord
  belongs_to :user
  belongs_to :member
  after_update :save_sales
  after_create :save_costs
  before_destroy :save_to_log
  before_destroy :reverse_account
  
  def as_json(options={})
        super.as_json(options).merge({user_name: get_user_name}).merge({starttime: formatted_starttime, endtime: formatted_endtime })
      end

    def get_user_name
      self.member && self.member.name
    end
    
    def formatted_starttime
      unless self.starttime == nil
        self.starttime.in_time_zone("Hong Kong").strftime('%a %b %d %H:%M:%S %Z %Y')
      end
    end
    def formatted_endtime
      unless self.endtime == nil
        self.endtime.in_time_zone("Hong Kong").strftime('%a %b %d %H:%M:%S %Z %Y')
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
    
    
    private
    
    def save_to_log
      Log.create(orderid: self.id, user_name: self.member.name, starttime: self.starttime, endtime: self.endtime, amount: self.amount, job_type: self.job_type, cost: self.cost, fixed_type: self.fixed_type)
    end
    
    def reverse_account
      unless self.amount == nil
        Account.first.update(sales: Account.first.sales - self.amount)
      end
      unless self.cost == nil
        Account.first.update(costs: Account.first.costs - self.cost)
      end
    end
end
