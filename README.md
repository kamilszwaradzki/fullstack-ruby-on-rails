# 'Grafik' czyli mała szkoła tańca

### Funkcje (MVP)

### Admin szkoły:

* dodaje kursy (np. „Salsa – początkujący”) i grupy (dzień, godzina, instruktor, limit miejsc),
* z harmonogramu grupy generuje zajęcia na cały miesiąc,
* odwołuje pojedyncze zajęcia, a zapisani dostają maila.

### Uczestnik (mobile-first):

* przegląda grafik i zapisuje się do grupy jednym kliknięciem (Turbo, bez przeładowania strony),
* gdy brak miejsc, trafia na listę rezerwową; gdy ktoś się wypisze, pierwsza osoba z listy wskakuje automatycznie i dostaje maila,
* widzi swoje zajęcia i stan karnetu.

### Instruktor:

* sprawdza obecność na telefonie (lista z checkboxami), a obecność zdejmuje wejście z karnetu.
## Model danych
```
User        (email, name, role: admin/instructor/participant)
Course      (name, description, level)
Group       (course_id, instructor_id, weekday, starts_at, duration, capacity)
Lesson      (group_id, starts_at, cancelled_at)
Enrollment  (user_id, group_id, status: active/waitlisted/cancelled, position)
Pass        (user_id, entries_total, entries_left, valid_until)
Attendance  (lesson_id, user_id, present)
```