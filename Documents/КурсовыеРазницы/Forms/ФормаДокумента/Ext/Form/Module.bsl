﻿
&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	Курс = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.Валюта, Объект.Дата);
	Объект.Курс = Курс.Курс;
	Объект.Кратность = Курс.Кратность;

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура КошелекПриИзменении(Элемент)
	Объект.Валюта = ОбщийМодуль1Сервер.ПолучитьВалютуВалютуКошелька(Объект.Кошелек);
	ВалютаПриИзменении(Неопределено)
КонецПроцедуры


&НаКлиенте
Процедура Рассчитать(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Вопрос("Перед выполнением этой операции требуется записать документ. ОК?", 
			РежимДиалогаВопрос.ОКОтмена,,КодВозвратаДиалога.Отмена) = КодВозвратаДиалога.Отмена Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Объект.Сумма = РассчитатьСервер();
	Модифицированность = Истина;
КонецПроцедуры

Функция РассчитатьСервер()

	//выполнить запрос по остаткам денег
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДенежныеСредстваОстатки.Кошелек,
	|	ДенежныеСредстваОстатки.СуммаОстаток,
	|	ДенежныеСредстваОстатки.СуммаРеглОстаток,
	|	ДенежныеСредстваОстатки.СуммаПрогнозОстаток,
	|	ДенежныеСредстваОстатки.СуммаПрогнозРеглОстаток
	|ИЗ
	|	РегистрНакопления.ДенежныеСредства.Остатки(&Граница) КАК ДенежныеСредстваОстатки";

	Если ЗначениеЗаполнено(Объект.Кошелек) Тогда
		запрос.Текст=запрос.Текст+"
		|ГДЕ
		|	ДенежныеСредстваОстатки.Кошелек = &Кошелек";
		Запрос.УстановитьПараметр("Кошелек", Объект.Кошелек);
	КонецЕсли;
	//на границу до даты этого документа
	ПараметрыГ = Новый Массив;
	//чтобы точно знать момент времени. если док уже существует - берем его время
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыГ.Добавить(Объект.Дата);
	Иначе
		//если это новый - берем начало дня
		ПараметрыГ.Добавить(НачалоДня(Объект.Дата));
	КонецЕсли;
		
	ПараметрыГ.Добавить(ВидГраницы.Исключая);  //так правильно
	//ПараметрыГ.Добавить(ВидГраницы.Включая);
	
	Граница = Новый (Тип("Граница"), ПараметрыГ);
	Запрос.УстановитьПараметр("Граница", Граница);

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		
		КурсЦБ 			= РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.Валюта, Объект.Дата);
		
		НовыйКурс 		= ?(ЗначениеЗаполнено(Объект.Курс), Объект.Курс, КурсЦБ.Курс);
		НоваяКратность 	= ?(ЗначениеЗаполнено(Объект.Кратность), Объект.Кратность, КурсЦБ.Кратность);
		
		Разница 		= ОбщийМодуль1Сервер.ПолучитьСуммуВВалютеРегл(Выборка.СуммаОстаток, Объект.Валюта, НовыйКурс, НоваяКратность)-Выборка.СуммаРеглОстаток;
		
		Возврат Разница;
		
	КонецЦикла;

КонецФункции

&НаКлиенте
Процедура ОбновитьКурс(Команда)
	ВалютаПриИзменении(Неопределено);
КонецПроцедуры
