﻿
&НаКлиенте
Функция ПолучитьПараметрыПодключения() 
	ПараметрыПодключения = Неопределено;

	ГуглАккаунт = СокрЛП(НРег(ЭтаФорма.ВладелецФормы.Объект.Аккаунт));

	Если Не ЗначениеЗаполнено(ГуглАккаунт) Тогда
		Сообщить("Не указан аккаунт Google!");
		Возврат Неопределено;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ЭтаФорма.ВладелецФормы.Объект.Пароль) Тогда
		Сообщить("Не указан пароль!");
		Возврат Неопределено;
	КонецЕсли;

	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("ГуглАккаунт", ГуглАккаунт);
	ПараметрыПодключения.Вставить("Пароль", ЭтаФорма.ВладелецФормы.Объект.Пароль);
	ПараметрыПодключения.Вставить("ПоправкаGMT", ЭтаФорма.ВладелецФормы.Объект.ПоправкаGMT);

	Возврат ПараметрыПодключения;
КонецФункции

//из модуля объекта конец

&НаКлиенте
Процедура ВыборПериода(Команда)
	ПеременнаяТипаСтандартныйПериод = Новый СтандартныйПериод;
	
	ПеременнаяТипаСтандартныйПериод.ДатаНачала = НачПериода;
	ПеременнаяТипаСтандартныйПериод.ДатаОкончания = КонПериода;
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = ПеременнаяТипаСтандартныйПериод;
	Если Диалог.Редактировать() Тогда 
	    ПеременнаяТипаСтандартныйПериод = Диалог.Период;
		
		НачПериода = ПеременнаяТипаСтандартныйПериод.ДатаНачала;
		КонПериода = ПеременнаяТипаСтандартныйПериод.ДатаОкончания;
		
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНапоминание(Команда)
	Перем пВидНапоминания,пНапомнитьЗаХМинут;
	ВидыНапоминаний=Новый СписокЗначений;
	
	ВидыНапоминаний.Добавить("Всплывающее окно");
	ВидыНапоминаний.Добавить("Электронная почта");
	ВидыНапоминаний.Добавить("SMS сообщение");
	//ТекНапоминания=Напоминания.ВыгрузитьКолонку("ВидНапоминания");
	//Если ТекНапоминания.Найти("SMS сообщение (Translit)")<>Неопределено Тогда
	//	ВидыНапоминаний.Добавить("SMS сообщение (Translit)");
	//ИначеЕсли ТекНапоминания.Найти("SMS сообщение (Cyrillic)")<>Неопределено Тогда
	//	ВидыНапоминаний.Добавить("SMS сообщение (Cyrillic)");	
	//Иначе	
	//	ВидыНапоминаний.Добавить("SMS сообщение (Translit)");
	//	ВидыНапоминаний.Добавить("SMS сообщение (Cyrillic)");
	//КонецЕсли;
	пВидНапоминания=ВидыНапоминаний.ВыбратьЭлемент("Выберите вид напоминания...");
	Если пВидНапоминания<>Неопределено Тогда
		пНапомнитьЗаХМинут=5;
		ВвестиЧисло(пНапомнитьЗаХМинут,"Напомнить за Х минут до начала события...",10,0);
		ТекНапоминание=Напоминания.Добавить();
		ТекНапоминание.ВидНапоминания=пВидНапоминания;
		ТекНапоминание.Минуты=пНапомнитьЗаХМинут;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНапоминание(Команда)
	ТекСтрока=Элементы.Напоминания.ТекущаяСтрока;
	Если ТекСтрока<>Неопределено Тогда
		Напоминания.Удалить(ТекСтрока);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВесьДень = Параметры.ВесьДень;
	НачПериода = Параметры.НачПериода;
	КонПериода = Параметры.КонПериода;
	Мероприятие = Параметры.Мероприятие;
	Описание = Параметры.Описание;
	Место = Параметры.Место;
	ФлагОперации = Параметры.ФлагОперации;
	Объект = Параметры.Объект;
	
	EntryId = Параметры.EntryId;
	GdEtag = Параметры.GdEtag;
	LinkEditHref = Параметры.LinkEditHref;
	
	ТабДеталФорма = ДанныеФормыВЗначение(Напоминания,Тип("ТаблицаЗначений"));	
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("EntryId", EntryId);
	НайденныеСтроки = Объект.Напоминания.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого Стр из НайденныеСтроки Цикл
		НовСтр = ТабДеталФорма.Добавить();
		НовСтр.ВидНапоминания = Стр.ВидНапоминания;
		НовСтр.Минуты = Стр.Минуты;
	КонецЦикла;
	
	ЗначениеВДанныеФормы(ТабДеталФорма, Напоминания);	
	
	//время для нового элемента
	ЭтоНовый = Параметры.ЭтоНовый;
	Если ЭтоНовый Тогда
		ДатаНачала = ТекущаяДата();
		ДатаОкончания = ТекущаяДата();
		
		//флаг Новый = Истина также тогда, когда элемент копируется
		//в новый элементв  этом случае надо поместить старые даты
		Если ФлагОперации = "Копировать" Тогда
			ДатаНачала = НачПериода;
			ДатаОкончания = КонПериода;
		ИначеЕсли ФлагОперации = "Создать" Тогда
			//сразу добавить напоминание за 5 минут до события
			ТекНапоминание=Напоминания.Добавить();
			ТекНапоминание.ВидНапоминания="Всплывающее окно";
			ТекНапоминание.Минуты=5;
				
	    КонецЕсли;
		
		//нужно при открытии нового показать ближайшее время начала, кратное получасу
		
		ВремяНачала = ОкруглитьВремя(ТекущаяДата());
		//увеличить время окончания на полчаса
		ВремяОкончания = ПрибавитьПолчаса(ВремяНачала);
	Иначе
		//надо разобрать переданные даты на части
		//ДатаНачала = Формат(НачПериода, "ДФ=дд.ММ.гггг");
		//ДатаОкончания = Формат(КонПериода, "ДФ=дд.ММ.гггг");
		ДатаНачала = НачПериода;
		ДатаОкончания = КонПериода;
		
		ВремяНачала = Формат(НачПериода,"ДФ=ЧЧ:мм");
		ВремяОкончания= Формат(КонПериода,"ДФ=ЧЧ:мм");
	КонецЕсли;
	
	Список = Элементы.ВремяНачала.СписокВыбора;
	Список2 = Элементы.ВремяОкончания.СписокВыбора;
	Для сч = 0 по 23 Цикл
		Время = ДополнитьНулямиСлева(сч, 2)+":"+"00";
		Список.Добавить(Время);
		Список2.Добавить(Время);
		Время = ДополнитьНулямиСлева(сч, 2)+":"+"30";
		Список.Добавить(Время);
		Список2.Добавить(Время);
	КонецЦикла;
	
	ЭтаФорма.Заголовок = Параметры.Мероприятие;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
//Параметры:
//	Время - тип дата, текущая дата
Функция ОкруглитьВремя(Время)
	ТекВремя = Прав(Время,8);
	Час = Число(Лев(ТекВремя,2));
	Мин = Число(Сред(ТекВремя,4,2));
	Сек = Число(Прав(ТекВремя,2));
	Если Мин > 30 Тогда
		//начало след часа
		Час = Час+1;
		Если Час = 24 Тогда
			Час = 0;
		КонецЕсли;
		
		Рез = ДополнитьНулямиСлева(Час, 2)+":00";
	Иначе
		Рез = ДополнитьНулямиСлева(Час, 2)+":30";
	КонецЕсли;
	Возврат Рез;
	
КонецФункции

&НаКлиенте
Процедура Сохранить(Команда)
	ПараметрыПодключения=ПолучитьПараметрыПодключения();
	Если ПараметрыПодключения = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	//сначала надо собрать время из кусочков
	//ДатаНачала = Формат(ДатаНачала, "ДФ=дд.ММ.
	НачПериода = Дата(Год(ДатаНачала),Месяц(ДатаНачала),День(ДатаНачала),Число(Лев(ВремяНачала,2)),Число(Прав(ВремяНачала,2)),0);
	КонПериода = Дата(Год(ДатаОкончания),Месяц(ДатаОкончания),День(ДатаОкончания),Число(Лев(ВремяОкончания,2)),Число(Прав(ВремяОкончания,2)),0);
	
	ПараметрыСобытия=Новый Структура("StartTime,EndTime,Title,Content,GdWhere,ВесьДень,Напоминания");
	ПараметрыСобытия.StartTime =  НачПериода; 				//Начало
	ПараметрыСобытия.EndTime =  КонПериода; 				//Конец
	ПараметрыСобытия.Title =  Мероприятие; 					//мероприятие (1024)
	ПараметрыСобытия.Content = Лев(СокрЛП(Описание),8130); 	//описание  (8130)
	ПараметрыСобытия.GdWhere =  Место; 						//Место  (255)
	ПараметрыСобытия.ВесьДень =  ВесьДень; 					//Событие на весь день
	ПараметрыСобытия.Напоминания = Напоминания;
	
	Если ФлагОперации="Создать" ИЛИ ФлагОперации="Копировать" Тогда			
		РезультатВставки = ВставитьСобытие(ПараметрыПодключения,ПараметрыСобытия);
		Если РезультатВставки <> "ОК" Тогда			
			Сообщить("Событие не создано!");
			Возврат;	
		Иначе
			//ПрочитатьСобытия();	
		КонецЕсли; 
	ИначеЕсли ФлагОперации="Изменить" Тогда
		Ответ = Вопрос("Вы действительно желаете изменить текущее событие?", РежимДиалогаВопрос.ДаНет, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		Иначе
			
			Событие=Новый Структура("LinkEditHref,GdEtag,EntryId,Title");				
			Событие.LinkEditHref = LinkEditHref;
			Событие.GdEtag = GdEtag;
			Событие.EntryId = EntryId;
			Событие.Title = Мероприятие;
			
			РезультатВставки = ВставитьСобытие(ПараметрыПодключения,ПараметрыСобытия,Событие);
			Если РезультатВставки <> "ОК" Тогда			
				Сообщить("Событие не изменено!");
				Возврат;	
			Иначе
				//ПрочитатьСобытия();	
			КонецЕсли; 
		КонецЕсли;		
						
	Иначе	
		Сообщить(ФлагОперации);	
	КонецЕсли;
	Закрыть("Запись");
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекстСобытия(ПараметрыСобытия, ПоправкаGMT) 
	ВерсияXML = "1.0";
	Кодировка = "UTF-8";
	Атом = "http://www.w3.org/2005/Atom";
	СхемаGoogleGd = "http://schemas.google.com/g/2005";
	СхемаGoogleGCal = "http://schemas.google.com/gCal/2005";

	ЕстьТранслит = Ложь;
	НапоминанияДляСобытия = ПараметрыСобытия.Напоминания;
	Если НапоминанияДляСобытия.Количество() > 0 Тогда
		ЗакрывающийТег = ">";
		ТекстНапоминания = "";
		Для каждого ТекНапоминание Из НапоминанияДляСобытия Цикл
			НапомнитьЗаХМинут = ТекНапоминание.Минуты;
			ВидНап = ТекНапоминание.ВидНапоминания;
			ВидНапоминания = ?(ВидНап = "Электронная почта", "email", ?(ВидНап = "Всплывающее окно", "alert", ?(Найти(ВидНап, "SMS сообщение") > 0, "sms", "")));
			Если Найти(ВидНап, "Translit") > 0 Тогда
				ЕстьТранслит = Истина;
			КонецЕсли;
			ТекстНапоминания = ТекстНапоминания + "<gd:reminder minutes=""" + НапомнитьЗаХМинут + """ method=""" + ВидНапоминания + """ />";
		КонецЦикла;
		ТекстНапоминания = ТекстНапоминания + "</gd:when>";
	Иначе
		ЗакрывающийТег = "/>";
	КонецЕсли;

	Если ПараметрыСобытия.ВесьДень Тогда
		ВремяНачалаСобытия = ВДатуRFC3339(ПараметрыСобытия.StartTime, ПоправкаGMT, 1);
		ВремяКонцаСобытия = ВДатуRFC3339(ПараметрыСобытия.EndTime, ПоправкаGMT, 1);
	Иначе
		ВремяНачалаСобытия = ВДатуRFC3339(ПараметрыСобытия.StartTime, ПоправкаGMT, 0);
		ВремяКонцаСобытия = ВДатуRFC3339(ПараметрыСобытия.EndTime, ПоправкаGMT, 0);
	КонецЕсли;

	Мероприятие = СокрЛП(ЗаменитьЗапрещенныеСимволы(?(ЕстьТранслит, Транслит(ПараметрыСобытия.Title), ПараметрыСобытия.Title)));
	Место = СокрЛП(ЗаменитьЗапрещенныеСимволы(?(ЕстьТранслит, Транслит(ПараметрыСобытия.GdWhere), ПараметрыСобытия.GdWhere)));
	Описание = СокрЛП(ЗаменитьЗапрещенныеСимволы(ПараметрыСобытия.Content));

	ТекстСобытия = "" + "<?xml version='" + ВерсияXML + "' encoding='" + Кодировка + "'?>" + "<entry xmlns='" + Атом + "' xmlns:gd='" + СхемаGoogleGd + "' xmlns:gCal='" + СхемаGoogleGCal + "'>" + "<title>" + Мероприятие + "</title>" + "<content>" + Описание + "</content>" + "<gd:where valueString='" + Место + "'/>";

	ТекстСобытия = ТекстСобытия + "<gd:when startTime='" + ВремяНачалаСобытия + "' endTime='" + ВремяКонцаСобытия + "'" + ЗакрывающийТег;
	ТекстСобытия = ТекстСобытия + ТекстНапоминания + "</entry>";

	Возврат ТекстСобытия;

КонецФункции

&НаКлиенте
Функция ВставитьСобытие(ПараметрыПодключения, ПараметрыСобытия, Событие = "") 
	Перем ПроверкаАккаунта;
	ПроверкаАккаунта = ПолучитьТокен(ПараметрыПодключения);
	Если Не ПроверкаАккаунта.Результат Тогда
		Возврат ПроверкаАккаунта.Значение;
	Иначе
		Токен = ПроверкаАккаунта.Значение;
	КонецЕсли;

	ВерсияGData = "2";

	Если Не ЗначениеЗаполнено(Событие) Тогда
        //новое событие
		УРЛ = "http://www.google.com/calendar/feeds/" + ПараметрыПодключения.ГуглАккаунт + "/private/full?v=" + ВерсияGData;

		ТекстСобытия = ПолучитьТекстСобытия(ПараметрыСобытия, ПараметрыПодключения.ПоправкаGMT);

		ХТТП = ПолучитьCOMОбъект("", "Microsoft.XMLHTTP");
		ХТТП.Open("POST", УРЛ, Ложь);
		ХТТП.SetRequestHeader("Content-Type", "application/atom+xml");
		ХТТП.SetRequestHeader("X-If-No-Redirect", "true");
		ХТТП.SetRequestHeader("Authorization", "GoogleLogin auth=" + Токен);
		ХТТП.Send(ТекстСобытия);

		ОбщийМодуль2Клиент.Пауза(3);
		
		Если ХТТП.Status = 201 Тогда
			Возврат "ОК";
		Иначе
			Возврат "Ошибка:" + ХТТП.Status + "-" + ХТТП.ResponseText;
		КонецЕсли;
	Иначе
        //редактирование существующего события
		Если ТипЗнч(Событие) <> Тип("Структура") Тогда
			Возврат "Не выбрано событие!!!";
		Иначе
			ТекущееСобытие = Событие;
		КонецЕсли;

		УРЛ = ТекущееСобытие.LinkEditHref;

		ТекстСобытия = ПолучитьТекстСобытия(ПараметрыСобытия, ПараметрыПодключения.ПоправкаGMT);

		ХТТП = ПолучитьCOMОбъект("", "Microsoft.XMLHTTP");
		ХТТП.Open("POST", УРЛ, Ложь);
		ХТТП.SetRequestHeader("Content-Type", "application/atom+xml");
		ХТТП.SetRequestHeader("X-HTTP-Method-Override", "PUT");
		ХТТП.SetRequestHeader("If-Match", "*");
		ХТТП.SetRequestHeader("Authorization", "GoogleLogin auth=" + Токен);
		ХТТП.Send(ТекстСобытия);

		ОбщийМодуль2Клиент.Пауза(3);
		
		Если ХТТП.Status = 200 Тогда
			Возврат "ОК";
		Иначе
			Возврат "Ошибка:" + ХТТП.Status + "-" + ХТТП.ResponseText;
		КонецЕсли;

	КонецЕсли;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВДатуRFC3339(Дата1С, ПоправкаGMT, КраткийФормат = 0) 
	ТемпДата = Дата1С - 60 * 60 * ПоправкаGMT;
	ТемпГод = СтрЗаменить(Формат(Год(ТемпДата), "ND=4; NLZ="), Символы.НПП, "");
	ТемпМесяц = Формат(Месяц(ТемпДата), "ND=2; NLZ=");
	ТемпДень = Формат(День(ТемпДата), "ND=2; NLZ=");

	Если КраткийФормат <> 0 Тогда
		ДатаRFC3339 = "" + ТемпГод + "-" + ТемпМесяц + "-" + ТемпДень;
	Иначе
		ТемпЧас = ?(Час(ТемпДата) = 0, "00", Формат(Час(ТемпДата), "ND=2; NLZ="));
		ТемпМинута = ?(Минута(ТемпДата) = 0, "00", Формат(Минута(ТемпДата), "ND=2; NLZ="));
		ТемпСекунда = ?(Секунда(ТемпДата) = 0, "00", Формат(Секунда(ТемпДата), "ND=2; NLZ="));
		ДатаRFC3339 = "" + ТемпГод + "-" + ТемпМесяц + "-" + ТемпДень + "T" + ТемпЧас + ":" + ТемпМинута + ":" + ТемпСекунда + ".000Z";
	КонецЕсли;

	Возврат ДатаRFC3339;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзДатыRFC3339(ДатаRFC3339, ПоправкаGMT)
	ТемпГод = Сред(ДатаRFC3339, 1, 4);
	ТемпМесяц = Сред(ДатаRFC3339, 6, 2);
	ТемпДень = Сред(ДатаRFC3339, 9, 2);

	Если СтрДлина(ДатаRFC3339) = 10 Тогда
		Дата1С = Дата(ТемпГод, ТемпМесяц, ТемпДень);
		Возврат Дата1С;
	КонецЕсли;

	ТемпЧас = Сред(ДатаRFC3339, 12, 2);
	ТемпМинута = Сред(ДатаRFC3339, 15, 2);
	ТемпСекунда = Сред(ДатаRFC3339, 18, 2);

	ТипДаты = Сред(ДатаRFC3339, 24, 1);

	Если ТипДаты = "Z" Тогда
		Дата1С = Дата(ТемпГод, ТемпМесяц, ТемпДень, ТемпЧас, ТемпМинута, ТемпСекунда) + 60 * 60 * ПоправкаGMT;
	Иначе
		ТемпGMT = Число(Сред(ДатаRFC3339, 24, 3));
		ТемпДата = Дата(ТемпГод, ТемпМесяц, ТемпДень, ТемпЧас, ТемпМинута, ТемпСекунда);
		Дата1С = ТемпДата - 60 * 60 * ТемпGMT + 60 * 60 * ПоправкаGMT;
	КонецЕсли;

	Возврат Дата1С;

КонецФункции

&НаКлиенте
Функция ЗаменитьЗапрещенныеСимволы(ТекстДляЗамены) 
	пТекстДляЗамены = ТекстДляЗамены;

	пТекстДляЗамены = СтрЗаменить(пТекстДляЗамены, "&", "&amp;");
	пТекстДляЗамены = СтрЗаменить(пТекстДляЗамены, """", "&quot;");
	пТекстДляЗамены = СтрЗаменить(пТекстДляЗамены, "<", "&lt;");
	пТекстДляЗамены = СтрЗаменить(пТекстДляЗамены, ">", "&gt;");
	пТекстДляЗамены = СтрЗаменить(пТекстДляЗамены, "'", "&#0039;");

	Возврат пТекстДляЗамены;

КонецФункции

&НаКлиенте
Функция Транслит(Стр) Экспорт
	Рус = "абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";
	Лат1 = "abvgdejzzijklmnoprstufkccss'y'ejjABVGDEJZZIJKLMNOPRSTUFKCCSS'Y'EJJ";
	Лат2 = "      oh  j           h hhh   hua      oh  j           h hhh   hua";
	Лат3 = "                          h                                h      ";

	КоличБукв = СтрДлина(Рус);
	Для сч = 1 По КоличБукв Цикл
		Стр = СтрЗаменить(Стр, Сред(Рус, сч, 1), СокрЛП(Сред(Лат1, сч, 1) + Сред(Лат2, сч, 1) + Сред(Лат3, сч, 1)));
	КонецЦикла;

	Возврат Стр;

КонецФункции

&НаКлиенте
Функция ПолучитьТокен(ПараметрыПодключения) 
	ПараметрыТокена = Новый Структура("Результат, Значение");

	ПараметрыТокена.Вставить("Результат", Ложь);
	ПараметрыТокена.Вставить("Значение", "Ошибка аутентификации!!!");

	Если ТипЗнч(ПараметрыПодключения) = Тип("Структура") И (ЗначениеЗаполнено(ПараметрыПодключения.ГуглАккаунт) И ЗначениеЗаполнено(ПараметрыПодключения.Пароль)) Тогда

		УРЛ = "https://www.google.com/accounts/ClientLogin";

		Попытка
			ХТТП = ПолучитьCOMОбъект("", "Microsoft.XMLHTTP");
			ХТТП.Open("POST", УРЛ, Ложь);
			ХТТП.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			ХТТП.Send("Email=" + ПараметрыПодключения.ГуглАккаунт + "&Passwd=" + ПараметрыПодключения.Пароль + "&service=cl&source=Gulp-CalGulp-1.05");
		Исключение
			Сообщить("Ошибка:" + ОписаниеОшибки());
			Возврат ПараметрыТокена;
		КонецПопытки;

		Если ХТТП.Status = 200 Тогда
			Токен = ХТТП.ResponseText;
			Токен = Прав(Токен, СтрДлина(Токен) - СтрДлина("Auth=") - Найти(Токен, "Auth=") + 1);

			ПараметрыТокена.Вставить("Результат", Истина);
			ПараметрыТокена.Вставить("Значение", Токен);
		Иначе


			ПараметрыТокена.Вставить("Результат", Ложь);
			ПараметрыТокена.Вставить("Значение", "Ошибка:" + ХТТП.Status + "-" + ХТТП.ResponseText);
		КонецЕсли;

	КонецЕсли;

	Возврат ПараметрыТокена;

КонецФункции

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Направление = 1 Тогда//вверх,  прибавляем
		
		ВремяНачала = ПрибавитьПолчаса(ВремяНачала);
	ИначеЕсли Направление = -1 Тогда//вниз, отнимаем
		
		ВремяНачала = ОтнятьПолчаса(ВремяНачала);
	КонецЕсли;
	
    ИзменитьВремяОкончания();
КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Функция ДополнитьНулямиСлева(Знач Парам, НужнаяДлина)
	Парам = Строка(Парам);
	ТекДлина = СтрДлина(Парам);
	КолвоНулей = НужнаяДлина - ТекДлина;
	Рез = "";
	Для сч = 1 по КолвоНулей Цикл
		Рез = Рез + "0";
	КонецЦикла;
	Возврат Рез+Парам;
	
КонецФункции


&НаКлиентеНаСервереБезКонтекста
//добавляет полчаса ко времени в параметре
Функция ПрибавитьПолчаса(ТекВремя)
	
	Час = Число(Лев(ТекВремя,2));
	Если Час > 23 Тогда	
		Час = 23;
	КонецЕсли;		
	Мин = Число(Сред(ТекВремя,4,2));
	Если Мин > 59 Тогда
		Мин = 59;
	КонецЕсли;
	Если Мин >= 30 Тогда
		//начало след часа
		Час = Час+1;
		Если Час = 24 Тогда
			Час = 0;
		КонецЕсли;
		
		Рез = ДополнитьНулямиСлева(Час, 2)+":00";
	Иначе
		Рез = ДополнитьНулямиСлева(Час, 2)+":30";
	КонецЕсли;
	Возврат Рез;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
//отнимает полчаса от времени в параметре
Функция ОтнятьПолчаса(ТекВремя)
	
	Час = Число(Лев(ТекВремя,2));
	Если Час > 23 Тогда	
		Час = 23;
	КонецЕсли;	
	Мин = Число(Сред(ТекВремя,4,2));
	Если Мин > 59 Тогда	
		Мин = 59;
	КонецЕсли;	
	
	Если Мин <= 30 Тогда
		//начало пред часа
		Час = Час-1;
		Если Час = 0 Тогда
			Час = 23;
		КонецЕсли;
		
		Рез = ДополнитьНулямиСлева(Час, 2)+":30";
	Иначе
		Рез = ДополнитьНулямиСлева(Час, 2)+":00";
	КонецЕсли;
	Возврат Рез;
	
КонецФункции


&НаКлиенте
//добавляет полчаса ко времени начала
Процедура ИзменитьВремяОкончания()
	ВремяОкончания = ПрибавитьПолчаса(ВремяНачала);
КонецПроцедуры

&НаКлиенте
//отнимает полчаса от времени окончания
Процедура ИзменитьВремяНачала()
	ВремяНачала = ОтнятьПолчаса(ВремяОкончания);
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Направление = 1 Тогда//вверх, прибавляем 
		
		ВремяОкончания = ПрибавитьПолчаса(ВремяОкончания);
	ИначеЕсли Направление = -1 Тогда//вниз, отнимаем
		
		ВремяОкончания = ОтнятьПолчаса(ВремяОкончания);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВесьДеньПриИзменении(Элемент)
	Если ВесьДень Тогда
		ВремяНачала = "00:00";
		ВремяОкончания = "00:00";
	КонецЕсли;
	УправлениеВидимостью();
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостью()
	Элементы.ВремяНачала.Видимость = НЕ ВесьДень;
	Элементы.ВремяОкончания.Видимость = НЕ ВесьДень;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеВидимостью();
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаПриИзменении(Элемент)
	ВремяНачала = ПроверкаВремени(ВремяНачала);
	ИзменитьВремяОкончания();
КонецПроцедуры

&НаКлиенте
Функция ПроверкаВремени(Время)
	Час = Число(Лев(Время,2));
	Если Час > 23 Тогда	
		Час = 23;
	КонецЕсли;	
	Мин = Число(Сред(Время,4,2));
	Если Мин > 59 Тогда	
		Мин = 59;
	КонецЕсли;
	Рез = ДополнитьНулямиСлева(Час,2)+":"+ДополнитьНулямиСлева(Мин,2);
	Возврат Рез;
КонецФункции

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	ДатаОкончания = ДатаНачала;
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияПриИзменении(Элемент)
	ВремяОкончания = ПроверкаВремени(ВремяОкончания);
	ИзменитьВремяНачала();
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВремяНачала = ВыбранноеЗначение;
	ВремяНачала = ПроверкаВремени(ВремяНачала);
	ИзменитьВремяОкончания();
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВремяОкончания = ВыбранноеЗначение;
	ВремяОкончания = ПроверкаВремени(ВремяОкончания);
	ИзменитьВремяНачала();

КонецПроцедуры
