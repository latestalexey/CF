﻿// Возвращает текстовую константу для формирования сообщений.
// Используется в целях локализации.
//
Функция ТекстДляАдминистратора() Экспорт
	
	Возврат НСтр("ru = 'Для администратора:'");
	
КонецФункции

// Возвращает пользовательский текст сообщения блокировки сеансов.
//
Функция ИзвлечьСообщениеБлокировки(Знач Сообщение) Экспорт
	
	ИндексМаркера = Найти(Сообщение, ТекстДляАдминистратора());
	Возврат ?(ИндексМаркера > 0, Сред(Сообщение, 1, ИндексМаркера - 3), Сообщение);
	
КонецФункции

