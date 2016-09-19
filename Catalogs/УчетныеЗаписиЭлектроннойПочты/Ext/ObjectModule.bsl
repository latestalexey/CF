﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьОбъектЗначениямиПоУмолчанию();
	
КонецПроцедуры

// Инициализирует новую учетную запись значениями по умолчанию
//
Процедура ЗаполнитьОбъектЗначениямиПоУмолчанию() Экспорт
	
	ИмяПользователя = "1С:Предприятие";
	SMTPАутентификация = Перечисления.ВариантыSMTPАутентификации.НеЗадано;
	ИспользоватьДляПолучения = Ложь;
	ОставлятьКопииСообщенийНаСервере = Ложь;
	ПериодХраненияСообщенийНаСервере = 0;
	ВремяОжидания = 30;
	SMTPАутентификация = Перечисления.ВариантыSMTPАутентификации.НеЗадано;
	СпособSMTPАутентификации = Перечисления.СпособыSMTPАутентификации.БезАутентификации;
	СпособPOP3Аутентификации = Перечисления.СпособыPOP3Аутентификации.Обычная;
	ПользовательSMTP = "";
	ПарольSMTP = "";
	ПортPOP3 = 110;
	ПортSMTP = 25;
	
КонецПроцедуры