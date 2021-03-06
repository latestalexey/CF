﻿
&НаКлиенте
Процедура Отмена(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	ЭтаФорма.Закрыть(Элементы.Шаблоны.ТекущиеДанные);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Шаблоны.Ссылка,
		|	Шаблоны.Кошелек,
		|	Шаблоны.СтатьяДР,
		|	Шаблоны.ВидОперации,
		|	Шаблоны.Сумма
		|ИЗ
		|	Справочник.Шаблоны КАК Шаблоны
		|ГДЕ
		|	Шаблоны.ВидДвижения = &ВидДвижения";

	Запрос.УстановитьПараметр("ВидДвижения", Параметры.ВидДвижения);

	Результат = Запрос.Выполнить().Выгрузить();
	
	ЗначениеВДанныеФормы(Результат, Шаблоны);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Ок(Неопределено);
КонецПроцедуры
