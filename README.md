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
## Testy i przypadki testowe
1. User
- [ ] Email jest wymagany.
- [ ] Email musi być unikalny.
- [ ] Rola musi należeć do dozwolonych wartości.
- [ ] Użytkownik może mieć wiele zapisów (Enrollment).
- [ ] Użytkownik może mieć wiele karnetów (Pass).
- [ ] Użytkownik może mieć wiele obecności (Attendance).
2. Course
- [ ] Nazwa jest wymagana.
- [ ] Opis jest opcjonalny (Do ustalenia).
- [ ] Poziom musi należeć do dozwolonych wartości.
- [ ] Kurs może mieć wiele grup.
- [ ] Usunięcie kursu nie powinno przypadkowo usuwać historii zajęć.
3. Group
- [ ] Grupa musi należeć do kursu.
- [ ] Grupa musi mieć instruktora.
- [ ] Instruktor musi być użytkownikiem z odpowiednią rolą.
- [ ] Dzień tygodnia musi mieścić się w zakresie 0–6 lub 1–7 (Do ustalenia).
- [ ] Godzina rozpoczęcia jest wymagana.
- [ ] Czas trwania musi być większy od zera.
- [ ] Pojemność musi być większa od zera.
- [ ] Grupa może mieć wiele lekcji.
- [ ] Grupa może mieć wiele zapisów.
4. Lesson
- [ ] Lekcja musi należeć do grupy.
- [ ] Data rozpoczęcia jest wymagana.
- [ ] Lekcja może być anulowana.
- [ ] Anulowana lekcja nie powinna być traktowana jako zrealizowana.
- [ ] Lekcja może mieć wiele rekordów obecności.
5. Enrollment
- [ ] Zapis musi należeć do użytkownika.
- [ ] Zapis musi należeć do grupy.
- [ ] Status musi należeć do dozwolonych wartości.
- [ ] Pozycja musi być nieujemna.
- [ ] Użytkownik nie może zapisać się dwa razy do tej samej grupy.
- [ ] Liczba aktywnych zapisów nie może przekroczyć pojemności grupy.
- [ ] Zmiana statusu zapisu powinna być poprawnie obsługiwana.
- [ ] Usunięcie zapisu nie powinno usuwać historii obecności.
6. Pass
- [ ] Karnet musi należeć do użytkownika.
- [ ] Łączna liczba wejść musi być większa od zera.
- [ ] Liczba pozostałych wejść nie może być ujemna.
- [ ] Liczba pozostałych wejść nie może przekraczać liczby całkowitej.
- [ ] Data ważności jest wymagana.
- [ ] Karnet jest ważny przed upływem terminu ważności.
- [ ] Karnet jest nieważny po upływie terminu ważności.
- [ ] Zużycie wejścia zmniejsza entries_left o jeden.
- [ ] Nie można zużyć wejścia z wyczerpanego karnetu.
- [ ] Nie można zużyć wejścia z wygasłego karnetu.
7. Attendance
- [ ] Obecność musi należeć do lekcji.
- [ ] Obecność musi należeć do użytkownika.
- [ ] Pole present jest wymagane.
- [ ] Użytkownik nie może mieć dwóch rekordów obecności na tej samej lekcji.
- [ ] Można oznaczyć użytkownika jako obecnego.
- [ ] Można oznaczyć użytkownika jako nieobecnego.
- [ ] Nie można rejestrować obecności na anulowanej lekcji.
- [ ] Użytkownik powinien być zapisany do grupy, do której należy lekcja.