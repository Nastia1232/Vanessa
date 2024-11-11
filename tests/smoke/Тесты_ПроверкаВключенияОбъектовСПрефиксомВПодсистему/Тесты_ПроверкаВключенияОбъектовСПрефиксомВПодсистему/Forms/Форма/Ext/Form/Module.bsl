﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ПрефиксОбъектов;
&НаКлиенте
Перем ИмяПодсистемы;
&НаКлиенте
Перем ВыводитьИсключения;
&НаКлиенте
Перем ИсключенияИзПроверок;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	Настройки(КонтекстЯдра, ИмяТеста());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	Инициализация(КонтекстЯдраПараметр);
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПрефиксОбъектов) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИмяПодсистемы) Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектыМетаданных = ОбъектыМетаданных(ПрефиксОбъектов);
	
	Для Каждого ОбъектМетаданных Из ОбъектыМетаданных Цикл
		
		Если Не ВыводитьИсключения Тогда
			МассивТестов = УбратьИсключения(ОбъектМетаданных.Значение);
		Иначе
			МассивТестов = ОбъектМетаданных.Значение;
		КонецЕсли;
		
		Если МассивТестов.Количество() Тогда
			НаборТестов.НачатьГруппу(ОбъектМетаданных.Ключ, Истина);;
		КонецЕсли;
		Для Каждого Тест Из МассивТестов Цикл
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьЧтоОбъектВключенВПодсистемы", 
				НаборТестов.ПараметрыТеста(Тест.ПолноеИмя), 
				Тест.ИмяТеста);	
		КонецЦикла;
		
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ПрефиксОбъектов = "";
	ИсключенияИзПроверок = Новый Соответствие;
	ВыводитьИсключения = Ложь;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");		
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;

	
	Если Настройки.Свойство("Префикс") Тогда
		ПрефиксОбъектов = ВРег(Настройки.Префикс);
	КонецЕсли;
	
	Если Настройки.Свойство("Подсистема") Тогда
		ИмяПодсистемы = Настройки.Подсистема;
	КонецЕсли;
	
	Если Настройки.Свойство("ВыводитьИсключения") Тогда
		ВыводитьИсключения = Настройки.ВыводитьИсключения;
	КонецЕсли;
		
	Если Настройки.Свойство("ИсключенияИзпроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки.ИсключенияИзпроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьЧтоОбъектВключенВПодсистемы(ПолноеИмяМетаданных) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);
	
	Результат = ПроверитьЧтоОбъектВключенВПодсистемыСервер(ПолноеИмяМетаданных, ИмяПодсистемы);
	Если Не Результат И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ТекстСообщения(ПолноеИмяМетаданных, ИмяПодсистемы));
	Иначе
		Утверждения.Проверить(Результат, ТекстСообщения(ПолноеИмяМетаданных, ИмяПодсистемы));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьЧтоОбъектВключенВПодсистемыСервер(ПолноеИмяМетаданных, ИмяПодсистемы)

	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);
	Подсистема = Метаданные.Подсистемы[ИмяПодсистемы];
	Результат = Ложь;
	
	Если Подсистема.Состав.Содержит(ОбъектМетаданных) Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенИзПроверок(ПолноеИмяМетаданных) Тогда
		ШаблонСообшения = НСтр("ru = 'Объект ""%1"" исключен из проверки'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообшения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
			
	Возврат Результат;

КонецФункции 

&НаКлиенте
Функция ИсключенИзПроверок(ПолноеИмяМетаданных)
	
	Результат = Ложь;
	МассивСтрокИмени = СтроковыеУтилиты.РазложитьСтрокуВМассивПодстрок(ПолноеИмяМетаданных, ".");
	ИслючениеВсехОбъектов = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1.*", МассивСтрокИмени[0]);
	
	Если ИсключенияИзПроверок.Получить(ВРег(ПолноеИмяМетаданных)) <> Неопределено
	 Или ИсключенияИзПроверок.Получить(ВРег(ИслючениеВсехОбъектов)) <> Неопределено Тогда
		Результат = Истина;	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция УбратьИсключения(МассивТестов)

	Результат = Новый Массив;
	
	Для Каждого Тест Из МассивТестов Цикл
		Если Не ИсключенИзПроверок(Тест.ПолноеИмя) Тогда
			Результат.Добавить(Тест);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Функция ТекстСообщения(ПолноеИмяМетаданных, ИмяПодсистемы)

	ШаблонСообщения = НСтр("ru = 'Объект ""%1"" не входит в подсистему ""%2"".'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных, ИмяПодсистемы);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция ОбъектыМетаданных(ПрефиксОбъектов)
	
	СтроковыеУтилиты = СтроковыеУтилиты();
	Пояснение = НСтр("ru = 'Проверка включения объекта с префиксом в подсистему'");;
	
	ОбъектыМетаданных = Новый Структура;
	ОбъектыМетаданных.Вставить("ОбщиеМодули", Новый Массив);
	ОбъектыМетаданных.Вставить("ПараметрыСеанса", Новый Массив);
	ОбъектыМетаданных.Вставить("Роли", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыОбмена", Новый Массив);
	ОбъектыМетаданных.Вставить("КритерииОтбора", Новый Массив);
	ОбъектыМетаданных.Вставить("ПодпискиНаСобытия", Новый Массив);
	ОбъектыМетаданных.Вставить("РегламентныеЗадания", Новый Массив);
	ОбъектыМетаданных.Вставить("ФункциональныеОпции", Новый Массив);
	ОбъектыМетаданных.Вставить("ПараметрыФункциональныхОпций", Новый Массив);
	ОбъектыМетаданных.Вставить("ОпределяемыеТипы", Новый Массив);
	ОбъектыМетаданных.Вставить("ХранилищаНастроек", Новый Массив);
	ОбъектыМетаданных.Вставить("ОбщиеФормы", Новый Массив);
	ОбъектыМетаданных.Вставить("ОбщиеКоманды", Новый Массив);
	ОбъектыМетаданных.Вставить("ГруппыКоманд", Новый Массив);
	ОбъектыМетаданных.Вставить("ОбщиеМакеты", Новый Массив);
	ОбъектыМетаданных.Вставить("ОбщиеКартинки", Новый Массив);
	ОбъектыМетаданных.Вставить("ПакетыXDTO", Новый Массив);
	ОбъектыМетаданных.Вставить("WebСервисы", Новый Массив); 
	ОбъектыМетаданных.Вставить("HTTPСервисы", Новый Массив);
	ОбъектыМетаданных.Вставить("ЭлементыСтиля", Новый Массив);
	ОбъектыМетаданных.Вставить("Стили", Новый Массив);
	ОбъектыМетаданных.Вставить("Константы", Новый Массив);
	ОбъектыМетаданных.Вставить("Справочники", Новый Массив);
	ОбъектыМетаданных.Вставить("Документы", Новый Массив);
	ОбъектыМетаданных.Вставить("ЖурналыДокументов", Новый Массив);
	ОбъектыМетаданных.Вставить("Перечисления", Новый Массив);
	ОбъектыМетаданных.Вставить("Отчеты", Новый Массив);
	ОбъектыМетаданных.Вставить("Обработки", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыВидовХарактеристик", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыСчетов", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыВидовРасчета", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыСведений", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыНакопления", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыБухгалтерии", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыРасчета", Новый Массив);
	ОбъектыМетаданных.Вставить("БизнесПроцессы", Новый Массив);
	ОбъектыМетаданных.Вставить("Задачи", Новый Массив);
	ОбъектыМетаданных.Вставить("ВнешниеИсточникиДанных", Новый Массив);
	
	Для Каждого Элемент Из ОбъектыМетаданных Цикл
		Для Каждого ОбъектМетаданных Из Метаданные[Элемент.Ключ] Цикл
			
			Если Не ИмяСодержитПрефикс(ОбъектМетаданных.Имя, ПрефиксОбъектов) Тогда
				Продолжить;
			КонецЕсли;
			
			Если Метаданные.ВнешниеИсточникиДанных.Содержит(ОбъектМетаданных) Тогда
				ОбъектыВнешнегоИсточникаДанных(ОбъектМетаданных, ОбъектыМетаданных[Элемент.Ключ], Пояснение);
			Иначе	
				
				ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1 [%2]", ОбъектМетаданных.ПолноеИмя(), Пояснение);
				
				СтруктураЭлемента = Новый Структура;
				СтруктураЭлемента.Вставить("ПолноеИмя", ОбъектМетаданных.ПолноеИмя());
				СтруктураЭлемента.Вставить("ИмяТеста", ИмяТеста);
				ОбъектыМетаданных[Элемент.Ключ].Добавить(СтруктураЭлемента);
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	Возврат ОбъектыМетаданных;

КонецФункции

&НаСервереБезКонтекста
Процедура ОбъектыВнешнегоИсточникаДанных(ОбъектМетаданных, КоллекцияОбъектовМетаданных, Пояснение)

	КоллекцииВнешнегоИсчтоникаДанных = Новый Структура;
	КоллекцииВнешнегоИсчтоникаДанных.Вставить("Таблицы", "Таблица");
	КоллекцииВнешнегоИсчтоникаДанных.Вставить("Кубы", "Куб");
	
	СтроковыеУтилиты = СтроковыеУтилиты();
	
	Для Каждого КоллекцияВнешнегоИсчтоникаДанных Из КоллекцииВнешнегоИсчтоникаДанных Цикл
		Для Каждого ОбъектВнешнегоИсчтоникаДанных Из ОбъектМетаданных[КоллекцияВнешнегоИсчтоникаДанных.Ключ] Цикл
			
			ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1 [%2]", ОбъектВнешнегоИсчтоникаДанных.ПолноеИмя(), Пояснение);
					
			СтруктураЭлемента = Новый Структура;
			СтруктураЭлемента.Вставить("ПолноеИмя", ОбъектВнешнегоИсчтоникаДанных.ПолноеИмя());
			СтруктураЭлемента.Вставить("ИмяТеста", ИмяТеста);
			КоллекцияОбъектовМетаданных.Добавить(СтруктураЭлемента);
			
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), Префикс) > 0;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтроковыеУтилиты()
	Возврат ВнешниеОбработки.Создать("СтроковыеУтилиты");	
КонецФункции 

&НаКлиенте
Функция ИмяТеста()
	
	Если Не ЗначениеЗаполнено(Объект.ИмяТеста) Тогда
		Объект.ИмяТеста = ИмяТестаНаСервере();
	КонецЕсли;
	
	Возврат Объект.ИмяТеста;
	
КонецФункции

&НаСервере
Функция ИмяТестаНаСервере()
	Возврат РеквизитФормыВЗначение("Объект").Метаданные().Имя;
КонецФункции

&НаКлиенте
Функция ВыполнятьТест(КонтекстЯдра)
	
	ВыполнятьТест = Ложь;
	ПутьНастройки = ИмяТеста();
	Настройки(КонтекстЯдра, ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат ВыполнятьТест;
	КонецЕсли;
		
	Если ТипЗнч(Настройки) = Тип("Структура") И Настройки.Свойство("Используется") Тогда
		ВыполнятьТест = Настройки.Используется;	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

#КонецОбласти