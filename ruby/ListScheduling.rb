# ListScheduling
require "./Task.rb"
require "./Recource.rb"
require "./Scheduling.rb"

tasks = Task.new().InputTaskInfo()
recource = Recource.new()
scheduling = Scheduling.new(tasks.length)
asap_end_time = scheduling.ASAP(tasks)
scheduling.ALAP(tasks, asap_end_time)
scheduling.ListScheduling(tasks, recource)
# p scheduling.asap
# p asap_end_time
# p scheduling.alap