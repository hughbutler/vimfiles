# super_admin
# rector
# pre_weekend_couple
# core
# leader
# fourth_day_couple

class Access

  def self.is user, required
    begin
      key = required.downcase.strip

      eligible = [key]
      eligible += ['rector', 'super_admin']

      eligible.include? user.try(:role).to_s
    end
  end

  def self.at_least user, required
    begin
      user.role.downcase == required.downcase.strip
    end
  end

end
