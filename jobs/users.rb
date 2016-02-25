require 'sequel'

users_total = 0

SCHEDULER.every '2s' do
  # get current registered
  users_total  = $DB[:users].count
  users_30_day = $DB[:users].where("created_at > CURRENT_DATE - INTERVAL '30' DAY").count
  users_1_day  = $DB[:users].where("created_at > CURRENT_DATE - INTERVAL '24' HOUR").count

  send_event('users_total', { current: users_total })
  send_event('users_30_day', { current: users_30_day })
  send_event('users_1_day', { current: users_1_day })

  send_event('synergy',   { value: rand(100) })
end