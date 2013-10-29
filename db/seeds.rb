# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create universities
University.create ([
	{ name: 'TMS', description: 'TMS administration' },
	{ name: 'NUS', description: 'A very awesome University. This is where Ken studied' },
	{ name: 'NTU', description: 'This is another awesome university' }
])

# Create departments
Department.create ([
	{ name: 'Technical', university: University.find_by_name('TMS') },
	{ name: 'Electrical and Computer Engineering', university: University.find_by_name('NUS') },
	{ name: 'Computer Science', university: University.find_by_name('NUS') },
	{ name: 'Computer Science', university: University.find_by_name('NTU') },
	{ name: 'Electrical Engineering', university: University.find_by_name('NTU') },
])

# Create admin users
User.create([
	{
		email: 'admin@tms.com',
		password: 'qwerty123',
		password_confirmation: 'qwerty123',
		first_name: 'Ken',
		last_name: 'Tran',
		title: 'Mr.',
		role: 'Admin',
		university: University.find_by_name('TMS'),
		university: Department.find_by_name('Technical')
	}
])