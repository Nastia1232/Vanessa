﻿
///////////////////////////////////////////////////
//Служебные функции и процедуры
///////////////////////////////////////////////////

&НаКлиенте
// контекст фреймворка Vanessa-ADD
Перем Ванесса;

&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;

&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-ADD.
Перем КонтекстСохраняемый Экспорт;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;

	ВсеТесты = Новый Массив;

	// описание шагов
	// пример вызова Ванесса.ДобавитьШагВМассивТестов(ВсеТесты, Снипет, ИмяПроцедуры, ПредставлениеТеста, ОписаниеШага, ТипШагаДляОписания, ТипШагаВДереве);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСбросилФлагВТестируемомЭкземпляре(Парам01)","ЯСбросилФлагВТестируемомЭкземпляре","И я сбросил флаг в тестируемом экземпляре ""ПроисходилЗапускTescClient""","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯУбедилсяЧтоФлагСнят(Парам01)","ЯУбедилсяЧтоФлагСнят","И я убедился, что флаг ""ПроисходилЗапускTescClient"" снят","","");

	Возврат ВсеТесты;
КонецФункции

&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции

&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции



///////////////////////////////////////////////////
//Работа со сценариями
///////////////////////////////////////////////////

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт

КонецПроцедуры

&НаКлиенте
// Процедура выполняется перед окончанием каждого сценария
Процедура ПередОкончаниемСценария() Экспорт
	Если Контекст.Свойство("ОткрытаяФормаVanessaADD") Тогда
		Если Контекст.ОткрытаяФормаVanessaADD.Открыта() Тогда
			Контекст.ОткрытаяФормаVanessaADD.Закрыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры



///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//И я сбросил флаг в тестируемом экземпляре "ПроисходилЗапускTescClient"
//@ЯСбросилФлагВТестируемомЭкземпляре(Парам01)
Процедура ЯСбросилФлагВТестируемомЭкземпляре(ИмяФлага) Экспорт
	Контекст.ОткрытаяФормаVanessaADD[ИмяФлага] = Ложь;
КонецПроцедуры

&НаКлиенте
//И я убедился, что флаг "ПроисходилЗапускTescClient" снят
//@ЯУбедилсяЧтоФлагСнят(Парам01)
Процедура ЯУбедилсяЧтоФлагСнят(ИмяФлага) Экспорт
	Если Контекст.ОткрытаяФормаVanessaADD[ИмяФлага] <> Ложь Тогда
		ВызватьИсключение "В тестируемом экземлпяре VB флаг <" + ИмяФлага + "> оказался равен Истина. А ожидали значение Ложь";
	КонецЕсли;

КонецПроцедуры
