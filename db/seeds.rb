# Users

User.find_or_create_by!(email_address: 'admin@example.com') do |user|
  user.name = 'Joanna Mazur'
  user.password = 'Admin123!'
  user.role = :admin
end
anna = User.find_or_create_by!(email_address: 'instructor@example.com') do |user|
  user.name = 'Anna Kowalska'
  user.password = 'Instructor456!'
  user.role = :instructor
end
tomasz = User.find_or_create_by!(email_address: 'instructor2@example.com') do |user|
  user.name = 'Tomasz Wiśniewski'
  user.password = 'Instructor2456!'
  user.role = :instructor
end
marek = User.find_or_create_by!(email_address: 'student@example.com') do |user|
  user.name = 'Marek Nowak'
  user.password = 'Student789!'
  user.role = :participant
end

ewa = User.find_or_create_by!(email_address: 'ewa.zielinska@example.com') do |user|
  user.name = 'Ewa Zielińska'
  user.password = 'Student789!'
  user.role = :participant
end
piotr = User.find_or_create_by!(email_address: 'piotr.wojcik@example.com') do |user|
  user.name = 'Piotr Wójcik'
  user.password = 'Student789!'
  user.role = :participant
end
katarzyna = User.find_or_create_by!(email_address: 'katarzyna.lewandowska@example.com') do |user|
  user.name = 'Katarzyna Lewandowska'
  user.password = 'Student789!'
  user.role = :participant
end
jakub = User.find_or_create_by!(email_address: 'jakub.kaminski@example.com') do |user|
  user.name = 'Jakub Kamiński'
  user.password = 'Student789!'
  user.role = :participant
end
magdalena = User.find_or_create_by!(email_address: 'magdalena.dabrowska@example.com') do |user|
  user.name = 'Magdalena Dąbrowska'
  user.password = 'Student789!'
  user.role = :participant
end
pawel = User.find_or_create_by!(email_address: 'pawel.zajac@example.com') do |user|
  user.name = 'Paweł Zając'
  user.password = 'Student789!'
  user.role = :participant
end

# Courses

salsa_beginner = Course.find_or_create_by!(name: 'Salsa – początkujący') do |course|
  course.description = 'Salsa dla początkujących'
  course.level = :beginner
end
salsa_intermediate = Course.find_or_create_by!(name: 'Salsa – średniozaawansowany') do |course|
  course.description = 'Salsa dla średniozaawansowanych'
  course.level = :intermediate
end
salsa_advanced = Course.find_or_create_by!(name: 'Salsa – tancerz') do |course|
  course.description = 'Salsa poziom HARD!'
  course.level = :advanced
end
bachata_beginner = Course.find_or_create_by!(name: 'Bachata – początkujący') do |course|
  course.description = 'Bachata dla początkujących'
  course.level = :beginner
end

# Groups
#
# Szukane po kurs + dzień, nie po starts_at: kolumna time jest zapisywana w UTC,
# a find_or_create_by! szuka po czasie lokalnym, więc nigdy by nie trafiło.

salsa_monday = Group.find_or_create_by!(course: salsa_beginner, weekday: 1) do |group|
  group.starts_at = '19:00'
  group.instructor = anna
  group.duration = 60
  group.capacity = 6
end
bachata_wednesday = Group.find_or_create_by!(course: bachata_beginner, weekday: 3) do |group|
  group.starts_at = '20:00'
  group.instructor = tomasz
  group.duration = 60
  group.capacity = 3 # pełna grupa z listą rezerwową
end
salsa_thursday = Group.find_or_create_by!(course: salsa_intermediate, weekday: 4) do |group|
  group.starts_at = '19:30'
  group.instructor = anna
  group.duration = 90
  group.capacity = 10
end
salsa_saturday = Group.find_or_create_by!(course: salsa_advanced, weekday: 6) do |group|
  group.starts_at = '11:00'
  group.instructor = tomasz
  group.duration = 90
  group.capacity = 8
end

groups = [ salsa_monday, bachata_wednesday, salsa_thursday, salsa_saturday ]

# Lessons

groups.each do |group|
  [ Date.current, Date.current.next_month ].each do |month|
    LessonsGeneratorService.new(group, month).call
  end
end

# Odwołujemy tylko, jeśli grupa nie ma jeszcze odwołanej przyszłej lekcji,
# inaczej każdy seed odwoływałby kolejną.
unless salsa_monday.lessons.where.not(cancelled_at: nil).where('starts_at > ?', Time.current).exists?
  salsa_monday.lessons
              .where(cancelled_at: nil)
              .where('starts_at > ?', 1.week.from_now)
              .order(:starts_at)
              .first
              &.update!(cancelled_at: Time.current)
end

# Generator tworzy lekcje tylko od dziś, więc przeszłe (z obecnościami) dodajemy ręcznie.
past_lessons = [ salsa_monday, bachata_wednesday ].to_h do |group|
  # ostatni poniedziałek / środa przed dziś
  days_back = (Date.current.wday - group.weekday) % 7
  days_back = 7 if days_back.zero?
  date = Date.current - days_back
  starts_at = Time.zone.local(date.year, date.month, date.day, group.starts_at.hour, group.starts_at.min)

  [ group, Lesson.find_or_create_by!(group: group, starts_at: starts_at) ]
end

# Passes
#
# entries_left tylko przy tworzeniu, żeby ponowny seed nie cofał wejść zdjętych przez AttendanceService.

Pass.find_or_create_by!(user: marek, entries_total: 8) do |pass|
  pass.valid_until = 1.month.from_now
  pass.entries_left = 6 # po obecności z zeszłego tygodnia: 5/8
end
Pass.find_or_create_by!(user: ewa, entries_total: 8) do |pass|
  pass.valid_until = 3.weeks.from_now
  pass.entries_left = 1
end
Pass.find_or_create_by!(user: piotr, entries_total: 8) do |pass|
  pass.valid_until = 3.days.from_now
  pass.entries_left = 4
end
Pass.find_or_create_by!(user: katarzyna, entries_total: 8) do |pass|
  pass.valid_until = 5.days.ago
  pass.entries_left = 2
end
Pass.find_or_create_by!(user: magdalena, entries_total: 4) do |pass|
  pass.valid_until = 1.month.from_now
  pass.entries_left = 4
end
Pass.find_or_create_by!(user: pawel, entries_total: 8) do |pass|
  pass.valid_until = 1.month.from_now
  pass.entries_left = 8
end
# Jakub celowo bez karnetu

# Enrollments
#
# Przez serwis: pełna grupa sama przerzuca na listę rezerwową,
# a ponowny seed dostaje :already_enrolled.

{
  salsa_monday => [ marek, ewa, piotr, katarzyna, jakub ],
  bachata_wednesday => [ marek, magdalena, pawel, ewa, jakub ],
  salsa_thursday => [ magdalena, pawel ],
  salsa_saturday => [ piotr ]
}.each do |group, users|
  users.each { |user| EnrollmentService.new(user, group).enroll }
end

# Attendances

AttendanceService.new(marek, past_lessons[salsa_monday]).mark_present
AttendanceService.new(jakub, past_lessons[salsa_monday]).mark_present
AttendanceService.new(piotr, past_lessons[salsa_monday]).mark_absent

AttendanceService.new(magdalena, past_lessons[bachata_wednesday]).mark_present
AttendanceService.new(pawel, past_lessons[bachata_wednesday]).mark_present
AttendanceService.new(marek, past_lessons[bachata_wednesday]).mark_absent
