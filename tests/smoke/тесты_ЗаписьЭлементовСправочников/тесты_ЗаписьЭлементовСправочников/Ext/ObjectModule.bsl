﻿#Область ОписаниеПеременных

Перем КонтекстЯдра;
Перем Утверждения;
Перем УтвержденияПроверкаТаблиц;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ИнтерфейсТестирования

Функция КлючНастройкиУстаревший()
	Возврат "ЗаписьЭлементовСправочников";
КонецФункции

Функция КлючНастройки()
	Если Не ЗначениеЗаполнено(ИмяТеста) Тогда
		ИмяТеста = Метаданные().Имя;
	КонецЕсли;
	
	Возврат ИмяТеста;
КонецФункции

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	
	ЗагрузитьНастройки();
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	ЗапросыИзБД = КонтекстЯдра.Плагин("ЗапросыИзБД");
	ЗапросыИзБД.Инициализация(КонтекстЯдра);
	
	
	ЗагрузитьНастройки();
	
	Если Не НужноВыполнятьТест() Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого МетаОбъект Из Метаданные.Справочники Цикл
		МожноМенять = ЗапросыИзБД.РазрешеноИзменятьОбъектВМоделиСервиса(МетаОбъект);
		
		Если МожноМенять И ПравоДоступа("Изменение", МетаОбъект) 
			И (Не Настройки.ОтборПоПрефиксу ИЛИ СтрНачинаетсяС(ВРег(МетаОбъект.Имя), ВРег(Настройки.Префикс))) Тогда
			
			ДобавитьТестыДляСправочника(НаборТестов, МетаОбъект);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Тесты

Процедура ПередЗапускомТеста() Экспорт
	
	НачатьТранзакцию();
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
	Если ТранзакцияАктивна() Тогда
		ОтменитьТранзакцию();
	КонецЕсли;
	
КонецПроцедуры

Процедура Тест_ЗаписатьЭлементСправочника(СправочникСсылка) Экспорт
	
	ЭлементОбъект = СправочникСсылка.ПолучитьОбъект();
	ЭлементОбъект.Записать();
	
КонецПроцедуры

Процедура Тест_ПропуститьЗаписьЭлементаСправочника(Знач Сообщение) Экспорт
	
	КонтекстЯдра.ПропуститьТест(Сообщение);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Настройки

Процедура ЗагрузитьНастройки()
	
	Если ЗначениеЗаполнено(Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ПлагинНастройки = КонтекстЯдра.Плагин("Настройки");
	ПлагинНастройки.Инициализация(КонтекстЯдра);
	
	НастройкиПоУмолчанию = НастройкиПоУмолчанию();
	Настройки = ПлагинНастройки.ПолучитьНастройку(КлючНастройки());
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Настройки = ПлагинНастройки.ПолучитьНастройку(КлючНастройкиУстаревший()); // обратная совместимость
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Настройки) ИЛИ ТипЗнч(Настройки) <> Тип("Структура") Тогда
		Настройки = НастройкиПоУмолчанию;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(НастройкиПоУмолчанию, Настройки);
	Настройки = НастройкиПоУмолчанию;
КонецПроцедуры

Функция НастройкиПоУмолчанию()
	
	Результат = Новый Структура;
	
	Результат.Вставить("Используется", Истина);
	Результат.Вставить("КоличествоПервыхЭлементов", 2);
	Результат.Вставить("КоличествоПоследнихЭлементов", 2);
	Результат.Вставить("Исключения", Новый Массив);
	Результат.Вставить("ВыводитьИсключения", Ложь);
	Результат.Вставить("Префикс", "");
	Результат.Вставить("ОтборПоПрефиксу", Ложь);
	
	Возврат Результат;
КонецФункции

Функция НужноВыполнятьТест()
	
	ЗагрузитьНастройки();
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	КлючНастройки = КлючНастройки();
	
	ВыполнятьТест = Истина;
	Если ТипЗнч(Настройки) = Тип("Структура")
		И Настройки.Свойство("Используется", ВыполнятьТест) Тогда
		
		Возврат ВыполнятьТест = Истина;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

Процедура ДобавитьТестыДляСправочника(НаборТестов, МетаОбъект)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ &КоличествоПервыхЭлементов
	|	Ссылка
	|ПОМЕСТИТЬ вт_Первые
	|ИЗ
	|	Справочник." + МетаОбъект.Имя + "
	|ГДЕ
	|	НЕ ЭтоГруппа И Не Предопределенный И Не ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ &КоличествоПоследнихЭлементов
	|	Ссылка
	|ПОМЕСТИТЬ вт_Последние
	|ИЗ
	|	Справочник." + МетаОбъект.Имя + "
	|ГДЕ
	|	НЕ ЭтоГруппа И Не Предопределенный И Не ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт_Первые.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ вт_Все
	|ИЗ
	|	вт_Первые КАК вт_Первые
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	вт_Последние.Ссылка
	|ИЗ
	|	вт_Последние КАК вт_Последние;
	|
	|ВЫБРАТЬ
	|	вт_Все.Ссылка,
	|   ПРЕДСТАВЛЕНИЕ(вт_Все.Ссылка) КАК Представление
	|ИЗ
	|	вт_Все КАК вт_Все";

	Запрос.Текст = СтрЗаменить(Запрос.Текст, 
								"ВЫБРАТЬ ПЕРВЫЕ &КоличествоПервыхЭлементов", 
								"ВЫБРАТЬ ПЕРВЫЕ " + Формат(Настройки.КоличествоПервыхЭлементов, "ЧГ=")
								);	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, 
								"ВЫБРАТЬ ПЕРВЫЕ &КоличествоПоследнихЭлементов", 
								"ВЫБРАТЬ ПЕРВЫЕ " + Формат(Настройки.КоличествоПоследнихЭлементов, "ЧГ=")
								);
	Если НЕ МетаОбъект.Иерархический 
		ИЛИ МетаОбъект.ВидИерархии <> Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "НЕ ЭтоГруппа", "ИСТИНА");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;	
	КонецЕсли; 
	
	ПредставлениеТеста = "Проверка записи элемента справочника - " + МетаОбъект.Имя;
	Сообщение = "Пропускаем из-за исключения по имени справочника - " + ПредставлениеТеста; 
	ЭтоИсключение = Ложь;
	
	Если КонтекстЯдра.ЕстьВИсключаемойКоллекции(МетаОбъект.Имя, Настройки.Исключения) Тогда
		КонтекстЯдра.Отладка(Сообщение); 
		
		Если Не Настройки.ВыводитьИсключения Тогда
		    Возврат;
		КонецЕсли;	
		
		ЭтоИсключение = Истина;
	КонецЕсли;
	
	НаборТестов.НачатьГруппу(МетаОбъект.Синоним + " - Справочник."  + МетаОбъект.Имя);
		
	Если ЭтоИсключение Тогда
		ПараметрыТеста = НаборТестов.ПараметрыТеста(Сообщение);
		НаборТестов.Добавить("Тест_ПропуститьЗаписьЭлементаСправочника", ПараметрыТеста, Сообщение);
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПараметрыТеста = НаборТестов.ПараметрыТеста(Выборка.Ссылка);
			ПредставлениеТеста = СтрШаблон("Проверка записи элемента справочника - %1", Выборка.Представление);
			
			НаборТестов.Добавить("Тест_ЗаписатьЭлементСправочника", ПараметрыТеста, ПредставлениеТеста);			
		КонецЦикла; 
	КонецЕсли;	

КонецПроцедуры

Функция ИмяТеста()
	
	Возврат Метаданные().Имя;
	
КонецФункции

#КонецОбласти