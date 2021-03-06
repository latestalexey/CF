﻿
// Обработчик регламентного задания по загрузке курса валют
//
Процедура ЗагрузитьАктуальныйКурс() Экспорт
	
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация, , ,
		НСтр("ru = 'Начата регламентная загрузка курсов валют'"));
		
	ТекущаяДата = ТекущаяДата();
	
	СообщениеОбОшибке = "";
	
	СостояниеЗагрузки = Неопределено;
	ПриЗагрузкеВозниклиОшибки = Неопределено;
	
	ОбработкаЗагрузкиКурсовВалют = Обработки.ЗагрузкаКурсовВалют.Создать();
	ОбработкаЗагрузкиКурсовВалют.НачалоПериодаЗагрузки = ТекущаяДата;
	ОбработкаЗагрузкиКурсовВалют.ОкончаниеПериодаЗагрузки = ТекущаяДата;
	ОбработкаЗагрузкиКурсовВалют.ЗаполнитьСписокВалют();
	ОбработкаЗагрузкиКурсовВалют.ЗагрузитьКурсыВалют(ПриЗагрузкеВозниклиОшибки);
	
	Если ПриЗагрузкеВозниклиОшибки Тогда
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, , ,
			НСтр("ru = 'Завершена регламентная загрузка курсов валют.'"));
	Иначе
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка, , ,
				НСтр("ru = 'Во время регламентного задания загрузки курсов валют возникли ошибки'"));
	КонецЕсли;
	
КонецПроцедуры

Функция СобытиеЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Валюты.Загрузка курсов валют'");
	
КонецФункции	
