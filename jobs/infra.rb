require 'sequel'

SCHEDULER.every '10s' do
  free_instances_running = $DB[:hosts].where("free = true AND state = 'running'").count
  free_instances_stopped = $DB[:hosts].where("free = true and state = 'stopped'").count
  paid_instances_running = $DB[:hosts].where("free = false AND state = 'running'").count

  send_event('free_instances_running', { current: free_instances_running })
  send_event('free_instances_stopped', { current: free_instances_stopped })
  send_event('paid_instances_running', { current: paid_instances_running })
end
