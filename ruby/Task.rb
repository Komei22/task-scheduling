# Task.rb
class Task
	attr_accessor :id, :resource, :exec_time, :next_tasks, :prev_tasks
	RESOURCE = 1
	EXECTIME = 2
	NEXTTASKS = 3

	def initialize
		@next_tasks = Array.new()
		@prev_tasks = Array.new()
	end

	def InputTaskInfo()
		tasks = Array.new()
		task_idx = 0
		File.foreach("task.txt") do |line|
			task = Task.new()
			task.id = task_idx
			tasks << SplitInf(line, task)
			task_idx += 1
		end
		SetPrevTasks(tasks)
		return tasks
	end

	def SplitInf(line, task)
		state = RESOURCE
		line.split(",").each do |token|
			case state
			when RESOURCE
				task.resource = token
				state = EXECTIME
				# puts(task.resource)
			when EXECTIME
				task.exec_time = token.to_i
				state = NEXTTASKS
				# puts(task.exec_time)
			when NEXTTASKS
				task.next_tasks << token.to_i
				# puts(task.next_tasks)
			else
			end
		end
		return task
	end

	def SetPrevTasks(tasks)
		for idx in 0..tasks.length-1 do
			tasks[idx].next_tasks.each do |n_task_idx|
				tasks[n_task_idx].prev_tasks << idx
			end
		end
	end
end
