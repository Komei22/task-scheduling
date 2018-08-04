# Scheduling.rb
require 'pqueue'

class Scheduling
	attr_accessor :asap, :alap, :scheduling, :assign_unit
	AVAILABLE = 1
	NONAVAILABLE = 0
	def initialize(task_num)
		@asap = Array.new(task_num, 0)
		@scheduling = Array.new(task_num, 0)
		@assign_unit = Array.new(task_num, -1)
	end

	def ASAP(tasks)
		q = Queue.new()
		in_edge = Array.new(tasks.length, 0) 
		for idx in 0..tasks.length-1 do
			in_edge[idx] = tasks[idx].prev_tasks.length
			if in_edge[idx] == 0 then q.push(idx) end
		end
		end_time = 0
		while !q.empty? do 
			task_idx = q.pop()
			finish_time = @asap[task_idx] + tasks[task_idx].exec_time
			end_time = [end_time, finish_time].max()
			tasks[task_idx].next_tasks.each do |n_task|
				@asap[n_task] = [@asap[n_task], finish_time].max()
				in_edge[n_task] -= 1
				if in_edge[n_task] == 0 then q.push(n_task) end
			end
		end
		return end_time
	end

	def ALAP(tasks, asap_end_time)
		@alap = Array.new(tasks.length, asap_end_time)
		q = Queue.new()
		out_edge = Array.new(tasks.length, 0)
		for idx in 0..tasks.length-1 do
			out_edge[idx] = tasks[idx].next_tasks.length
			if out_edge[idx] == 0 then 
				q.push(idx) 
				@alap[idx] -= tasks[idx].exec_time
			end
		end
		start_time = asap_end_time
		while !q.empty? do
			task_idx = q.pop()
			start_time = @alap[task_idx]
			tasks[task_idx].prev_tasks.each do |p_task|
				@alap[p_task] = [@alap[p_task], start_time - tasks[p_task].exec_time].min()
				out_edge[p_task] -= 1
				if out_edge[p_task] == 0 then q.push(p_task) end
			end
		end
	end

	def EvaluateTask(task_idx)
		return alap[task_idx] - asap[task_idx]
	end

	def ListScheduling(tasks, resource)
		# unitの初期化
		available_units = Array.new(resource.units.length, AVAILABLE)
		units_type = Array.new
		resource.units.map { |unit|  
			units_type << unit[0]
		}

		pq = PQueue.new(){ |a,b| a[0] < b[0] }

		# 入り枝
		in_edge = Array.new(tasks.length, 0)
		for idx in 0..tasks.length-1 do
			in_edge[idx] = tasks[idx].prev_tasks.length
			if in_edge[idx] == 0 then 
				pq.push([EvaluateTask(idx), idx])
			end
		end

		finish_tasks = Queue.new
		wait_tasks = Queue.new
		end_time = 0
		current_time = 0
		while !pq.empty? || available_units.all? { |unit| unit != NONAVAILABLE}
			task_idx = pq.pop[1]
			is_assign = false
			for unit_idx in 0..units_type.length-1
				if units_type[unit_idx] == tasks[task_idx].resource && available_units[unit_idx] == AVAILABLE
					is_assign = true
					available_units[unit_idx] = NONAVAILABLE
					@assign_unit[task_idx] = unit_idx
					@scheduling[task_idx] = current_time
					finish_time = current_time + tasks[task_idx].exec_time
					end_time = [end_time, finish_time].max
					finish_tasks.push([task_idx, finish_time])
					break;
				end
				if !is_assign && unit_idx == units_type.length-1
					wait_tasks.push
				end
			end
		end
	end



end