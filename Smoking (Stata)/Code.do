/// Пункт (1,2)
//Зависимая переменная
gen visit = 1 if q46 == 2
replace visit = 2 if q46 == 3
replace visit = 3 if q46 == 1
gen male = 1 if q1==1 // Пол
replace male =0 if q1==2
gen income_ = q99/q76 // Доход на члена семьи
replace income_ = . if q99==9
gen age_ = q2 // Возраст
gen smoke_ = 1 if q34 == 1 | q34 == 2 // Курение
replace smoke_ = 0 if q34 == 3 | q34 == 4
gen health=1 if q5==1 | q5==2 // Следит ли за здоровьем
replace health=0 if q5==3 | q5==4

/// Пункт (3)
gen indicate = 1 if visit !=. & male !=. & income_ !=. & age_ !=. & smoke_ !=. & health !=. 
by visit, sort: sum male income_ age_ smoke_ health if indicate==1

/// Пункт (4)
ologit visit i.male c.age c.income_ i.smoke_ i.health
est store ologit
predict pologit1 pologit2 pologit3
sum pologit1 pologit2 pologit3 visit if pologit1 !=. & visit !=.
tab visit if indicate==1

/// Пункт (5)
ologit visit i.male c.income_ c.age_ i.health
est store m0
ologit visit i.male c.age c.income_ i.health if smoke_==1
est store m_s
ologit visit i.male c.age c.income_ i.health if smoke_==0
est store m_ns
lrtest m0 (m_s m_ns)

/// Пункт (6)
ologit visit i.male  c.age c.income_ i.health c.income_#c.income_ if smoke_==1
est store m_s_inc
ologit visit i.male  c.age c.income_ i.health c.income_#c.income_ if smoke_==0
est store m_ns_inc

/// Пункт (7)
ologit visit i.male  c.age c.income_ i.health c.income_#c.income_ if smoke_==0
est store ologit_no_smoke
ologit visit c.age c.income_ i.health c.income_#c.income_ if smoke_==0
est store ologit_no_smoke_rest
lrtest ologit_no_smoke ologit_no_smoke_rest

/// Пункт (8)
ologit visit i.male  c.age c.income_ i.health c.income_#c.income_ if smoke_==0
estat ic
ologit visit c.age c.income_ i.health c.income_#c.income_ if smoke_==0
estat ic

/// Пункт (10)
tab visit if smoke_==0 & indicate==1
by visit, sort: sum income_ age_ health if indicate==1 & smoke_==0

/// Пункт (11)
ologit visit c.age c.income_ i.health c.income_#c.income_ if smoke_==0
margins, dydx(income_) predict(outcome(3)) at(health=1 income_ = (400(2000)100000))
marginsplot

/// Пункт (12)
ologit visit c.income_ c.age i.health c.income_#c.income_ if smoke_==0
margins, predict(outcome(3)) at(health=1 income_ = (400(2000)100000))
marginsplot

/// Пункт (13)
ologit visit c.income_ c.age i.health c.income_#c.income_ if smoke_==0
oparallel

/// Пункт (14)
gen income_sqr = income_^2
gologit2 visit income_ age health income_sqr if smoke_==0
est store gologit

/// Пункт (15)
gologit2 visit income_ age health income_sqr if smoke_==0, gamma
est store gologit_gamma

