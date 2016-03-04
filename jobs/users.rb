require 'sequel'

users_total = 0

SCHEDULER.every '2m' do
  users_1_day  = $DB[:users].where("created_at >= NOW() - INTERVAL '24' HOUR").count
  users_30_day = $DB[:users].where("created_at >= NOW() - INTERVAL '30' DAY").count
  users_total  = $DB[:users].count
  users_active = $DB[:users].distinct.join(:containers, :user_id=>:id).where("containers.updated_at > NOW() - INTERVAL '30' DAY").count

  send_event('users_1_day', { current: users_1_day })
  send_event('users_30_day', { current: users_30_day })
  send_event('users_total', { current: users_total })
  send_event('users_active', { current: users_active })
end
