﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ТабДок = Новый ТабличныйДокумент;
	Ссылка = ПараметрКоманды;
	//ПараметрКоманды = Новый Структура("Ссылка, Дерево",Ссылка,ПараметрыВыполненияКоманды.Источник.Элементы.Таблица1); 
	ПараметрКоманды = Новый Структура("Ссылка",Ссылка); 
	ПечатьБДРМоя(ТабДок, ПараметрКоманды);

	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.ПоказатьУровеньГруппировокСтрок(0);
	ТабДок.Показать();
КонецПроцедуры


&НаСервере
Процедура ПечатьБДРМоя(ТабДок, ПараметрКоманды)
	Документы.БюджетГод.ПечатьБДРМоя(ТабДок, ПараметрКоманды);
КонецПроцедуры
