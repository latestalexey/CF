﻿//не получается настроить сортировку статей по полю Порядок
//при попытке установить это поле для сортировки в настройках СКД
//оно говорит, что поле Порядок не найдено

//&НаСервере
//Функция РезультатОбработкаРасшифровкиСервер(Расшифровка)
//	
//	Перем ВыполненноеДействие;
//	 
//	ОтчетСервер = ДанныеФормыВЗначение(Отчет, Тип("ОтчетОбъект.БюджетДоходовИРасходов"));
//	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтчетСервер.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных"));
//	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, ИсточникДоступныхНастроек);
//	Данные = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
//	МассивПолей = Данные.Элементы[Расшифровка].ПолучитьПоля();
//	ПолеРасшифровки = Новый ПолеКомпоновкиДанных(МассивПолей[0]);
//	Настройки = ОбработкаРасшифровки.Расшифровать(Расшифровка, ПолеРасшифровки);
//	
//	Отбор = Новый Структура("Вариант, СтатьяДР, НачалоПериода, КонецПериода");
//	
//	Если Настройки = Неопределено Тогда
//		Возврат Отбор;
//	КонецЕсли;	
//	
//	Отбор.Вставить("Вариант", ОтчетСервер.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.найти("Вариант").Значение);
//	Для Каждого Эл Из Настройки.Отбор.Элементы Цикл
//		
//		Если Эл.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатьяДР") Тогда
//			Отбор.Вставить("СтатьяДР", Эл.ПравоеЗначение);
//			
//		ИначеЕсли Эл.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Период") Тогда
//			
//			Если ТипЗнч(Эл.ПравоеЗначение) = Тип("Дата") Тогда
//				Отбор.Вставить("НачалоПериода", НачалоМесяца(Эл.ПравоеЗначение));
//				Отбор.Вставить("КонецПериода",  КонецМесяца (Эл.ПравоеЗначение));
//			Иначе
//				//выбрали колоку "СтатьяДР"
//				Отбор.Вставить("НачалоПериода", НачалоГода(Эл.ПравоеЗначение.Дата));
//				Отбор.Вставить("КонецПериода",  КонецГода (Эл.ПравоеЗначение.Дата));
//				
//			КонецЕсли;
//		КонецЕсли;
//	КонецЦикла;	
//	
//	Возврат Отбор;
//	
//КонецФункции

//&НаКлиенте
//Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
//	Перем ВыполненноеДействие;

//	СтандартнаяОбработка = Ложь;
//	
//	Отбор = РезультатОбработкаРасшифровкиСервер(Расшифровка);
//	
//	ПараметрыФормы = Новый Структура("Отбор, КлючНазначенияИспользования, КлючВарианта, СформироватьПриОткрытии");
//	ПараметрыФормы.СформироватьПриОткрытии = Истина;
//	ПараметрыФормы.КлючНазначенияИспользования = "РасшифровкаСтатьиБюджета";
//	ПараметрыФормы.КлючВарианта = "Основной";
//	
//	ПараметрыФормы.Отбор = Отбор;
//	
//	ОткрытьФорму("Отчет.ВедомостьПоСтатьямДР.Форма", ПараметрыФормы);
//	
//КонецПроцедуры

&НаСервере
Функция СформироватьОтчетСервер(ТекстОшибки =  "")
	
	ДеревоБДР = ОбщийМодуль1Сервер.СоздатьДеревоБДР();
	
	ПарамГруппаСтатей = Неопределено;
	ПарамДатаНач = Неопределено;
	ПарамДатаКон = Неопределено;
	
	Для каждого Эл Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если Эл.Параметр = Новый ПараметрКомпоновкиДанных("ТекПериод") Тогда
			ПарамДатаНач = Эл.Значение.ДатаНачала;
			ПарамДатаКон = Эл.Значение.ДатаОкончания;
		ИначеЕсли Эл.Параметр = Новый ПараметрКомпоновкиДанных("ГруппаСтатей") Тогда
			Если Эл.Использование Тогда
				ПарамГруппаСтатей = Эл.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураПараметров = Новый Структура("ДеревоБДРФорма, НачПериода, КонПериода",
	ДеревоБДР, ПарамДатаНач, ПарамДатаКон);
	
	ОбщийМодуль1Сервер.ЗаполнитьДеревоИзСправочникаСервер(СтруктураПараметров);
	
	ВключатьПодчиненные = Истина;
	СтрокаДерева = ДеревоБДР.Строки.Найти(ПарамГруппаСтатей,"СтатьяДР", ВключатьПодчиненные);
	Если СтрокаДерева = Неопределено Тогда
		СтрокаДерева = ДеревоБДР;
	КонецЕсли;
	
	ТаблицаБДР = Новый ТаблицаЗначений;
	ТаблицаБДР.Колонки.Добавить("Факт");
	ТаблицаБДР.Колонки.Добавить("Статья");
	
	Для Каждого Стр Из СтрокаДерева.Строки Цикл
		Если Стр.Факт13=0 Тогда
			Продолжить;
		КонецЕсли;
		НовСтр = ТаблицаБДР.Добавить();
		НовСтр.Статья = Стр.СтатьяДР;
		НовСтр.Факт = Окр(Стр.Факт13,0,1);
	КонецЦикла;
		
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаБДР", ТаблицаБДР);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Схема = Отчеты.СтруктураСтатьи.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");

	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Отчет.КомпоновщикНастроек.Настройки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных,,Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	
	//убирает надпись "Отчет не сформирован"
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения  = ДополнительныйРежимОтображения.НеИспользовать;
	Элементы.Результат.ОтображениеСостояния.Видимость  = Ложь;
	
	Результат.Очистить();
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Результат.ПоказатьУровеньГруппировокСтрок(1);
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьОтчет(Команда)
	ТекстОшибки = "";
	Рез = СформироватьОтчетСервер(ТекстОшибки);
	Если НЕ Рез Тогда
		Предупреждение(ТекстОшибки, 120);
	КонецЕсли;
КонецПроцедуры


