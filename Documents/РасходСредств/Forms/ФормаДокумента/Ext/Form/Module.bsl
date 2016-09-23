﻿&НаСервереБезКонтекста
Функция ПолучитьДатуЗапретаРедактирования()

	Возврат Константы.ДатаЗапретаРедактирования.Получить();

КонецФункции // ПолучитьДатуЗапретаРедактирования()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НачалоДня(Объект.Дата)<=ПолучитьДатуЗапретаРедактирования() Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	УправлениеВидимостьюКлиент();
	
	//Если Не ЗначениеЗаполнено(Объект.Валюта) И ЗначениеЗаполнено(Объект.Кошелек) Тогда
	//	Объект.Валюта = Получитьва
	//	ВалютаПриИзменении(Неопределено);
	//ИначеЕсли Не ЗначениеЗаполнено(Объект.Валюта) Тогда
	//	Объект.Валюта = ПолучитьВалютуРеглУчетаСервер();
	//	ВалютаПриИзменении(Неопределено);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостьюКлиент()
	
	Элементы.ДетализацияПоНоменклатуре.Видимость = Объект.СуммыВТабЧасти;
	
	Элементы.Контрагент.Видимость = Объект.ДетализацияПоНоменклатуре;
	
	Элементы.ДоходыРасходыНоменклатура.Видимость = Объект.ДетализацияПоНоменклатуре;
	Элементы.ДоходыРасходыКоличество.Видимость = Объект.ДетализацияПоНоменклатуре;
	
	Элементы.СуммаТЧ.Видимость = Объект.СуммыВТабЧасти;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияПоНоменклатуреПриИзменении(Элемент)
	УправлениеВидимостьюКлиент();
	Если НЕ Объект.ДетализацияПоНоменклатуре Тогда
		Объект.Контрагент = "";
		Для каждого Стр Из Объект.ДоходыРасходы Цикл
			Стр.Номенклатура = "";
			Стр.Количество = 0;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	Курс = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.Валюта, Объект.Дата);
	Объект.Курс = Курс.Курс;
	Объект.Кратность = Курс.Кратность;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВалютуРеглУчетаСервер()
	Возврат Константы.ВалютаРегламентированногоУчета.Получить();
КонецФункции


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Если ЗначениеЗаполнено(ЭтаФорма.Параметры.СтатьяДР) Тогда
	//	НовСтр = Объект.ДоходыРасходы.Добавить();
	//	НовСтр.СтатьяДР = ЭтаФорма.Параметры.СтатьяДР;
	//КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СуммыВТабЧастиПриИзменении(Элемент)
	УправлениеВидимостьюКлиент()
КонецПроцедуры


&НаКлиенте
Процедура КошелекПриИзменении(Элемент)
	Объект.Валюта = ОбщийМодуль1Сервер.ПолучитьВалютуКошелька(Объект.Кошелек);
	ВалютаПриИзменении(Неопределено)
КонецПроцедуры



&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	//ВалютаПриИзменении(Неопределено)
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьДопРасходы(Команда)
	Всего = 0;
	Для каждого Стр Из Объект.ДоходыРасходы Цикл
		Всего = Всего + Стр.Сумма;
	КонецЦикла;
	
	Если Всего =0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Стр Из Объект.ДоходыРасходы Цикл
		Стр.ДопСумма = Стр.Сумма / Всего * Объект.ДопРасходы;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДату(Команда)
	ДеньМесяца = Число(этаформа.ТекущийЭлемент.Заголовок);
	Объект.Дата = Дата(Год(Объект.Дата), Месяц(Объект.Дата), ДеньМесяца);
	Модифицированность = Истина;
КонецПроцедуры




