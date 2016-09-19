﻿
&НаКлиенте
Процедура ПолучитьОтбор(Команда)
	Закрыть(ПолучитьРезультат());
КонецПроцедуры

&НаСервере
Функция ПолучитьРезультат()
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ТекстЗапроса", ТекстЗапроса);
	СтруктураРезультата.Вставить("ТекстПроизвольногоЗапроса", ТекстПроизвольногоЗапроса);
	СтруктураРезультата.Вставить("СтрокаПоиска", СтрокаПоиска);
	СтруктураРезультата.Вставить("Настройки", ОтборДанных.ПолучитьНастройки());
	СтруктураРезультата.Вставить("РежимПоиска", РежимПоиска);
	СтруктураРезультата.Вставить("ПараметрыЗапроса", ПараметрыЗапроса);
	
	Возврат СтруктураРезультата;
КонецФункции

&НаСервере
Процедура ЗаполнитьНастройки()
	
	СхемаКомпоновки = ПолучитьСхемуКомпоновки();		
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновки, УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);	
		
	ОтборДанных.Инициализировать(ИсточникНастроек); 
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСхемуКомпоновки()
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных();		
    	
	Источник = СхемаКомпоновки.ИсточникиДанных.Добавить();
	Источник.Имя = "Источник1";
	Источник.СтрокаСоединения="";
	Источник.ТипИсточникаДанных = "local";
	
	НаборДанных = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Запрос = ТекстЗапроса;
	НаборДанных.Имя = "Запрос";
	НаборДанных.ИсточникДанных = "Источник1";
	
	Возврат СхемаКомпоновки;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекстЗапроса = Параметры.ТекстЗапроса;
	ТекстПроизвольногоЗапроса = Параметры.ТекстПроизвольногоЗапроса;
	СтрокаПоиска = Параметры.СтрокаПоиска;
	
	Элементы.РежимПоиска.СписокВыбора.Добавить(0, "Отбор по реквизитам");
	Элементы.РежимПоиска.СписокВыбора.Добавить(1, "Произвольный запрос");
	
	РежимПоиска = Параметры.РежимПоиска;
	ПараметрыЗапроса.Загрузить(Параметры.ПараметрыЗапроса.Выгрузить());
	
	Заголовок = Заголовок + " [" + Параметры.ОбъектПоиска.Представление + "]";
	ЗаполнитьНастройки();
	
	Настройки = Параметры.Настройки;
	Если Настройки <> Неопределено Тогда
		ОтборДанных.ЗагрузитьНастройки(Настройки);
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура КонструкторЗапроса(Команда)
	#Если ТолстыйКлиентУправляемоеПриложение  Тогда
	КонструкторЗапроса = Новый КонструкторЗапроса;
	
	Если НЕ ПустаяСтрока(ТекстЗапроса) Тогда 
		КонструкторЗапроса.Текст = ТекстЗапроса;
	КонецЕсли;
	
	Если КонструкторЗапроса.ОткрытьМодально() Тогда 
		ТекстЗапроса = КонструкторЗапроса.Текст;
	КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметры(Команда)
	Результат = ЗаполнитьПараметрыЗапроса();
	Если Результат <> Истина Тогда
		Предупреждение(Результат, 60, "Ошибка!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПараметрыЗапроса()
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		Возврат "Отсутствует текст запроса.";
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстПроизвольногоЗапроса);
	Попытка
		ПараметрыВЗапросе = Запрос.НайтиПараметры();
	Исключение
		Возврат ОписаниеОшибки();
	КонецПопытки;
	
	Для каждого ПараметрЗапроса Из ПараметрыВЗапросе Цикл
		ИмяПараметра =  ПараметрЗапроса.Имя;
		СтрокаПараметров = ПараметрыЗапроса.НайтиСтроки(Новый Структура("ИмяПараметра", ИмяПараметра));
		Если  СтрокаПараметров.Количество() = 0 Тогда
			СтрокаПараметров = ПараметрыЗапроса.Добавить();
			СтрокаПараметров.ИмяПараметра = ИмяПараметра;
		Иначе 
			СтрокаПараметров = СтрокаПараметров[0];
		КонецЕсли; 
		
		СтрокаПараметров.ЗначениеПараметра = ПараметрЗапроса.ТипЗначения.ПривестиЗначение(СтрокаПараметров.ЗначениеПараметра);
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ПараметрыЗапросаЗначениеПараметраОчистка(Элемент, СтандартнаяОбработка)
	Элемент.ВыбиратьТип = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РежимПоискаПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Если РежимПоиска = 1 Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ПроизвольныйЗапрос;
	Иначе
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ОтборПоЗначениямРеквизитов;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ТолстыйКлиентУправляемоеПриложение  Тогда
	Элементы.КонтекстноеМенюТекстЗапросаКонструкторЗапроса.Доступность = Истина;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОтборДанныхНастройкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ОтборДанныхНастройкиПередНачаломИзменения(Элемент, Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ОтборДанныхНастройкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НЕ НоваяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	
	
КонецПроцедуры
