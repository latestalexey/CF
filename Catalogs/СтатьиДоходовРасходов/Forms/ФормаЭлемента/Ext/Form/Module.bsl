﻿
&НаКлиенте
Процедура ЭтоСбережениеПриИзменении(Элемент)
	УправлениеВидимостьюКлиент()
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостьюКлиент()
	
	Элементы.СрокНакопления.Видимость = Объект.ЭтоСбережение;
	Элементы.СуммаНакопления.Видимость = Объект.ЭтоСбережение;
	Элементы.СтатьяВозвратаСбережения.Видимость = Объект.ЭтоСбережение;
	Элементы.СтатьяСбережения.Видимость = Объект.ЭтоСбережение;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеВидимостьюКлиент();
КонецПроцедуры
