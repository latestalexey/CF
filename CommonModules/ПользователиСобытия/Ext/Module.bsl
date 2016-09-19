﻿
////////////////////////////////////////////////////////////////////////////////
// Процедуры используемые при обмене данными

// Переопределяет стандартное поведение при выгрузке данных.
// Реквизит ИдентификаторПользователяИБ не переносится.
//
Процедура ПриОтправкеДанных(ЭлементДанных, ОтправкаЭлемента) Экспорт
	
	Если ОтправкаЭлемента = ОтправкаЭлементаДанных.Удалить
		ИЛИ ТипЗнч(ЭлементДанных) = Тип("УдалениеОбъекта") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.Пользователи")
	 ИЛИ ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ВнешниеПользователи") Тогда
		ЭлементДанных.ИдентификаторПользователяИБ = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	КонецЕсли;
	
КонецПроцедуры

// Переопределяет стандартное поведение при загрузке данных.
// Реквизит ИдентификаторПользователяИБ не переносится, т.к. всегда
// связан с пользователем текущей базы или не связан с пользователем.
//
Процедура ПриПолученииДанных(ЭлементДанных) Экспорт
	
	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.Пользователи")
	 ИЛИ ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ВнешниеПользователи") Тогда
		ЭлементДанных.ИдентификаторПользователяИБ = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ЭлементДанных.Ссылка, "ИдентификаторПользователяИБ");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ПОДПИСОК НА СОБЫТИЯ
//

// Обработчик ОбновитьПредставлениеВнешнегоПользователя события ПриЗаписи подписки на события
// "ОбновитьПредставлениеВнешнегоПользователя" вызывает метод записи представления внешнего пользователя.
// Тип СправочникСсылка.ВнешниеПользователи используется для целей поставки непустого списка типов в
// подписке на событие.
//  В состав подписки следует включить типы объектов авторизации,
// например, Справочник.ФизическиеЛица, Справочник.Контрагенты
//
Процедура ОбновитьПредставлениеВнешнегоПользователя(Знач Объект, Отказ) Экспорт
	
	Если Объект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Объект.Ссылка) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		Возврат;
	КонецЕсли;
	
	ВнешниеПользователи.ОбновитьПредставлениеВнешнегоПользователя(Объект.Ссылка);
	
КонецПроцедуры

