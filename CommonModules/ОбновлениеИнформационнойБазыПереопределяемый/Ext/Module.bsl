﻿///////////////////////////////////////////////////////////////////////////////
// ИНТЕРФЕЙСНАЯ ЧАСТЬ ПЕРЕОПРЕДЕЛЯЕМОГО МОДУЛЯ

// Возвращает список процедур-обработчиков обновления ИБ для всех поддерживаемых версий ИБ.
//
// Пример добавления процедуры-обработчика в список:
//    Обработчик = Обработчики.Добавить();
//    Обработчик.Версия = "1.0.0.0";
//    Обработчик.Процедура = "ОбновлениеИБ.ПерейтиНаВерсию_1_0_0_0";
//
// Вызывается перед началом обновления данных ИБ.
//
Функция ОбработчикиОбновления() Экспорт
	
	Обработчики = ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления();
	
	// Подключаются процедуры-обработчики обновления конфигурации
	//
	// _Демо начало примера
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.0.0";
	//Обработчик.Процедура = "_ДемоОбновлениеИБ.ПерейтиНаВерсию_1_0_0_0";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.0.5";
	//Обработчик.Процедура = "_ДемоОбновлениеИБ.ПерейтиНаВерсию_1_0_0_5";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "*";
	//Обработчик.Процедура = "_ДемоОбновлениеИБ.ВыполнятьВсегдаПриСменеВерсии";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.2.2";
	//Обработчик.Процедура = "_ДемоОбновлениеИБ.ИнициализироватьРолиИсполнителей";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.5.1";
	//Обработчик.Процедура = "_ДемоОбновлениеИБ.ИнициализироватьПользователей";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.5.1";
	//Обработчик.Процедура = "_ДемоОбновлениеИБ.ИнициализироватьПраваДоступа";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.6.8";
	//Обработчик.Процедура = "_ДемоОбновлениеИБ.ДобавитьДополнительныеОбработкиВИБ";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.7.1";
	//Обработчик.Процедура = "_ДемоОбновлениеИБ.ПереименоватьРоли_1_0_7_1";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.7.1";
	//Обработчик.Процедура = "_ДемоОбновлениеИБ.ОбновитьВариантыОтчетов_1_0_7_1";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.1.2";
	//Обработчик.Процедура = "Пользователи.ПриНаличииГруппПользователейУстановитьИспользование";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.1.2.1";
	//Обработчик.Процедура = "_ДемоОбновлениеИБ.ПереименоватьРоли_1_1_2";
	// _Демо конец примера
	
	Возврат Обработчики;
	
КонецФункции

// Вызывается после завершении обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсияИБ     - Строка - версия ИБ до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсияИБ        - Строка - версия ИБ после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков
//                                             обновления, сгруппированных по номеру версии.
//  Итерирование по выполненным обработчикам:
//		Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//	
//			Если Версия.Версия = "*" Тогда
//				группа обработчиков, которые выполняются всегда
//			Иначе
//				группа обработчиков, которые выполняются для определенной версии 
//			КонецЕсли;
//	
//			Для Каждого Обработчик Из Версия.Строки Цикл
//				...
//			КонецЦикла;
//	
//		КонецЦикла;
//
//   ВыводитьОписаниеОбновлений - Булево -	если Истина, то выводить форму с описанием 
//											обновлений.
// 
Процедура ПослеОбновления(Знач ПредыдущаяВерсияИБ, Знач ТекущаяВерсияИБ, 
	Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений) Экспорт
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений системы.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновлений.
//   
// См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры	

