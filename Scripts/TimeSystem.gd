extends Node2D

signal time_passed(date_time)

var speed := 65

var prev_time := 0.0
var time := 0.0

class DateTime:
	var second
	var minute
	var hour
	var day
	var month
	var year
	
	func _init(time):
		var int_time = int(floor(time))
		second = int_time % 60
		minute = (int_time / 60) % 60
		hour = (int_time / (60 * 60)) % 24
		day = (int_time / (60 * 60 * 24)) % 30
		month = (int_time / (60 * 60 * 24 * 30)) % 12
		year = (int_time / (60 * 60 * 24 * 30 * 12))
#		print("seconds:" , second, " minutes:",  minute, " hour:", hour, " day:", day, " month:", month, " year:", year)
	
	func equals_year(year):
		return self.year == year
	
	func equals_month(month):
		return self.month == month
	
	func equals_day(day):
		return self.day == day
	
	func equals_hour(hour):
		return self.hour == hour
	
	func equals_minute(minute):
		return self.minute == minute
	
	func equals_second(second):
		return self.second == second
	
	func equals(second, minute, hour, day):
		return self.second == second and self.minute == minute and self.hour == hour and self.day == day


func _process(delta):
	if get_tree().has_group("World"):
		time += delta * speed
		
		var date_times = []
		var int_time = floor(time)
		var prev_int_time = floor(prev_time)
		while prev_int_time < int_time:
			var new = DateTime.new(prev_int_time)
			date_times.append(new)
			prev_int_time += 1
		
		emit_signal("time_passed", date_times)
		
		prev_time = time


#func _on_time_passed(date_times):
#	for dt in date_times:
#		if dt.equals(10, 0, 0, 0):
#			color = Color("#FF0000")
