﻿# language: ru

@IgnoreOnCIMainBuild
@tree


Функционал: Загрузить фичу в vanessa-add
	Как Разработчик
	Я Хочу чтобы чтобы у меня была возможность выполнить шаги начиная с группы


Сценарий: Загрузка тестовой фичи проверка работы до брейкпоинта

	Дано  Я запоминаю значение выражения "1" в переменную "Количество"
	Когда Я увеличил значение "СлужебныйПараметр" в КонтекстСохраняемый на 1
	И Это группа
		И     Я увеличил значение "СлужебныйПараметр" в КонтекстСохраняемый на 10
		И     Я увеличил значение "СлужебныйПараметр" в КонтекстСохраняемый на 10
	И     Я увеличил значение "СлужебныйПараметр" в КонтекстСохраняемый на 1
	И     Я увеличил значение "СлужебныйПараметр" в КонтекстСохраняемый на 1
	И     Я могу продолжить выполнение шагов в хост системе
