﻿
////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции прикладного разработчика
//

// Функция ИспользоватьВнешнихПользователей() возвращает
// значение функциональной опции ИспользоватьВнешнихПользователей.
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользоватьВнешнихПользователей() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	//прог
	Возврат Ложь;//Константы.ИспользоватьВнешнихПользователей.Получить();
	
КонецФункции

// Получает значение параметра сеанса "Текущий внешний пользователь"
//
// Возвращаемое значение:
//  СправочникСсылка.ВнешниеПользователи
//
Функция ТекущийВнешнийПользователь() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ТекущийВнешнийПользователь;
	
КонецФункции

// Функция ПолучитьОбъектАвторизацииВнешнегоПользователя возвращает объект
// авторизации внешнего пользователя, полученный из информационной базы.
//  ОбъектАвторизации - это ссылка на объект информационной базы, используемый
// для связи с внешним пользователем, например, контрагенты, физические лица и т.д.
//
// Параметры
//  ВнешнийПользователь - СправочникСсылка.ВнешниеПользователи
//
// Возвращаемое значение:
//  Метаданные.Справочники.ВнешниеПользователи.Реквизиты.ОбъектыАвторизации.Тип
//
Функция ПолучитьОбъектАвторизацииВнешнегоПользователя(ВнешнийПользователь) Экспорт
	
	Возврат ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ВнешнийПользователь, "ОбъектАвторизации").ОбъектАвторизации;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Внутренние процедуры и функции
//

// Процедура ОбновитьСоставГруппВнешнихПользователей обновляет в регистре сведений
// "Состав групп пользователей" соответствие групп внешних пользователей и внешних пользователей
// с учетом иерархии групп внешних пользователей (родитель включает внешних пользователей порожденных групп).
//  Эти данные требуются для формы списка и формы выбора внешних пользователей.
//  Данные регистра могут быть применены в других целях для повышения производительности,
// т.к. не требуется работать с иерархией на языке запросов.
//
// Параметры:
//  ГруппаВнешнихПользователей - СправочникСсылка.ГруппыВнешнихПользователей
//
Процедура ОбновитьСоставГруппВнешнихПользователей(Знач ГруппаВнешнихПользователей, ИзмененныеВнешниеПользователи = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ГруппаВнешнихПользователей) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Подготовка групп родителей.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаГруппРодителей.Родитель,
	|	ТаблицаГруппРодителей.Ссылка
	|ПОМЕСТИТЬ ТаблицаГруппРодителей
	|ИЗ
	|	&ТаблицаГруппРодителей КАК ТаблицаГруппРодителей");
	Запрос.УстановитьПараметр("ТаблицаГруппРодителей", Пользователи.ТаблицаГруппРодителей("Справочник.ГруппыВнешнихПользователей"));
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	ИзмененныеВнешниеПользователи = Новый ТаблицаЗначений;
	ИзмененныеВнешниеПользователи.Колонки.Добавить("ВнешнийПользователь", Новый ОписаниеТипов("СправочникСсылка.ВнешниеПользователи"));
	
	// Выполнение для текущий группы и каждой группы-родителя.
	Пока НЕ ГруппаВнешнихПользователей.Пустая() Цикл
		
		Запрос.УстановитьПараметр("ГруппаВнешнихПользователей", ГруппаВнешнихПользователей);
		СвойстваГруппы = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ГруппаВнешнихПользователей, "ТипОбъектовАвторизации, ВсеОбъектыАвторизации");
		ТипОбъектовАвторизации = ?(СвойстваГруппы.ВсеОбъектыАвторизации, СвойстваГруппы.ТипОбъектовАвторизации, Неопределено);
		
		Если ГруппаВнешнихПользователей <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи И
		     ТипОбъектовАвторизации = Неопределено Тогда
			
			// Удаление связей для удаленных пользователей.
			Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	СоставГруппПользователей.Пользователь КАК ВнешнийПользователь
			|ИЗ
			|	РегистрСведений.СоставГруппПользователей КАК СоставГруппПользователей
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыВнешнихПользователей.Состав КАК ГруппыВнешнихПользователейСостав
			|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаГруппРодителей КАК ТаблицаГруппРодителей
			|			ПО (ТаблицаГруппРодителей.Ссылка = ГруппыВнешнихПользователейСостав.Ссылка)
			|				И (ТаблицаГруппРодителей.Родитель = &ГруппаВнешнихПользователей)
			|		ПО (СоставГруппПользователей.ГруппаПользователей = &ГруппаВнешнихПользователей)
			|			И СоставГруппПользователей.Пользователь = ГруппыВнешнихПользователейСостав.ВнешнийПользователь
			|ГДЕ
			|	СоставГруппПользователей.ГруппаПользователей = &ГруппаВнешнихПользователей
			|	И ГруппыВнешнихПользователейСостав.Ссылка ЕСТЬ NULL ";
			ВнешниеПользователиУдаленныеИзГруппы = Запрос.Выполнить().Выбрать();
			МенеджерЗаписи = РегистрыСведений.СоставГруппПользователей.СоздатьМенеджерЗаписи();
			Пока ВнешниеПользователиУдаленныеИзГруппы.Следующий() Цикл
				МенеджерЗаписи.ГруппаПользователей = ГруппаВнешнихПользователей;
				МенеджерЗаписи.Пользователь        = ВнешниеПользователиУдаленныеИзГруппы.ВнешнийПользователь;
				МенеджерЗаписи.Удалить();
				ИзмененныеВнешниеПользователи.Добавить().ВнешнийПользователь = ВнешниеПользователиУдаленныеИзГруппы.ВнешнийПользователь;
			КонецЦикла;
		КонецЕсли;
		
		// Добавление связей для добавленных внешних пользователей.
		Если ГруппаВнешнихПользователей = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ЗНАЧЕНИЕ(Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи) КАК ГруппаПользователей,
			|	ВнешниеПользователи.Ссылка КАК Пользователь
			|ИЗ
			|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставГруппПользователей КАК СоставГруппПользователей
			|		ПО (СоставГруппПользователей.ГруппаПользователей = ЗНАЧЕНИЕ(Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи))
			|			И (СоставГруппПользователей.Пользователь = ВнешниеПользователи.Ссылка)
			|ГДЕ
			|	СоставГруппПользователей.Пользователь ЕСТЬ NULL 
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	ВнешниеПользователи.Ссылка,
			|	ВнешниеПользователи.Ссылка
			|ИЗ
			|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставГруппПользователей КАК СоставГруппПользователей
			|		ПО (СоставГруппПользователей.ГруппаПользователей = ВнешниеПользователи.Ссылка)
			|			И (СоставГруппПользователей.Пользователь = ВнешниеПользователи.Ссылка)
			|ГДЕ
			|	СоставГруппПользователей.Пользователь ЕСТЬ NULL ";
			
		ИначеЕсли ТипОбъектовАвторизации <> Неопределено Тогда
			Запрос.УстановитьПараметр("ТипОбъектовАвторизации", ТипЗнч(ТипОбъектовАвторизации));
			Запрос.Текст =
			"ВЫБРАТЬ
			|	&ГруппаВнешнихПользователей КАК ГруппаПользователей,
			|	ВнешниеПользователи.Ссылка КАК Пользователь
			|ИЗ
			|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставГруппПользователей КАК СоставГруппПользователей
			|		ПО (СоставГруппПользователей.ГруппаПользователей = &ГруппаВнешнихПользователей)
			|			И (СоставГруппПользователей.Пользователь = ВнешниеПользователи.Ссылка)
			|ГДЕ
			|	СоставГруппПользователей.Пользователь ЕСТЬ NULL 
			|	И ТИПЗНАЧЕНИЯ(ВнешниеПользователи.ОбъектАвторизации) = &ТипОбъектовАвторизации";
		Иначе
			Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	&ГруппаВнешнихПользователей КАК ГруппаПользователей,
			|	ГруппыВнешнихПользователейСостав.ВнешнийПользователь КАК Пользователь
			|ИЗ
			|	Справочник.ГруппыВнешнихПользователей.Состав КАК ГруппыВнешнихПользователейСостав
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаГруппРодителей КАК ТаблицаГруппРодителей
			|		ПО (ТаблицаГруппРодителей.Ссылка = ГруппыВнешнихПользователейСостав.Ссылка)
			|			И (ТаблицаГруппРодителей.Родитель = &ГруппаВнешнихПользователей)
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставГруппПользователей КАК СоставГруппПользователей
			|		ПО (СоставГруппПользователей.ГруппаПользователей = &ГруппаВнешнихПользователей)
			|			И (СоставГруппПользователей.Пользователь = ГруппыВнешнихПользователейСостав.ВнешнийПользователь)
			|ГДЕ
			|	СоставГруппПользователей.Пользователь ЕСТЬ NULL ";
		КонецЕсли;
		
		ВнешниеПользователиДобавленныеВГруппу = Запрос.Выполнить().Выгрузить();
		
		Если ВнешниеПользователиДобавленныеВГруппу.Количество() > 0 Тогда
		
			НаборЗаписей = РегистрыСведений.СоставГруппПользователей.СоздатьНаборЗаписей();
			НаборЗаписей.Загрузить(ВнешниеПользователиДобавленныеВГруппу);
			НаборЗаписей.Записать(Ложь); // Добавление недостающих записей связей.
			
			Для каждого ОписаниеВнешнегоПользователя Из ВнешниеПользователиДобавленныеВГруппу Цикл
				ИзмененныеВнешниеПользователи.Добавить().ВнешнийПользователь = ОписаниеВнешнегоПользователя.Пользователь;
			КонецЦикла;
		КонецЕсли;
		
		ГруппаВнешнихПользователей = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ГруппаВнешнихПользователей, "Родитель");
	КонецЦикла;
	
	ИзмененныеВнешниеПользователи.Свернуть("ВнешнийПользователь");
	ИзмененныеВнешниеПользователи = ИзмененныеВнешниеПользователи.ВыгрузитьКолонку("ВнешнийПользователь");
	
КонецПроцедуры

// Процедура ОбновитьРолиВнешнихПользователей обновляет список ролей пользователей
// информационной базы по их текущим принадлежностям к группам внешних пользователей.
// 
// Параметры:
//  МассивВнешнихПользователей - Массив элементов СправочникСсылка.ВнешниеПользователи.
//  ЕстьОшибки - Булево. Возвращает истина, когда были ошибки, записанные в журнал регистрации.
//
Процедура ОбновитьРолиВнешнихПользователей(Знач МассивВнешнихПользователей, ЕстьОшибки = Ложь) Экспорт
	
	Если ПользователиПереопределяемый.ЗапретРедактированияРолей() Тогда
		// Роли устанавливаются другим механизмом, например, механизмом подсистемы УправлениеДоступом.
		Возврат;
	КонецЕсли;
	
	Если МассивВнешнихПользователей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторыПользователейИБ = Новый Соответствие;
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВнешниеПользователи.Ссылка КАК ВнешнийПользователь,
		|	ВнешниеПользователи.ИдентификаторПользователяИБ
		|ИЗ
		|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
		|ГДЕ
		|	ВнешниеПользователи.Ссылка В(&ВнешниеПользователи)
		|	И (НЕ ВнешниеПользователи.УстановитьРолиНепосредственно)");
	Запрос.УстановитьПараметр("ВнешниеПользователи", МассивВнешнихПользователей);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ИдентификаторыПользователейИБ.Вставить(Выборка.ВнешнийПользователь, Выборка.ИдентификаторПользователяИБ);
	КонецЦикла;
	
	// Подготовка таблицы старых ролей внешних пользователей.
	СтарыеРолиВнешнихПользователей = Новый ТаблицаЗначений;
	СтарыеРолиВнешнихПользователей.Колонки.Добавить("ВнешнийПользователь", Новый ОписаниеТипов("СправочникСсылка.ВнешниеПользователи"));
	СтарыеРолиВнешнихПользователей.Колонки.Добавить("Роль", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(200)));
	
	ТекущийНомер = МассивВнешнихПользователей.Количество() - 1;
	Пока ТекущийНомер >= 0 Цикл
		// Проверка необходимости обработки пользователя.
		ПользовательИБ = Неопределено;
		ИдентификаторПользователяИБ = ИдентификаторыПользователейИБ[МассивВнешнихПользователей[ТекущийНомер]];
		Если ИдентификаторПользователяИБ <> Неопределено Тогда
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);
		КонецЕсли;
		Если ПользовательИБ = Неопределено ИЛИ ПустаяСтрока(ПользовательИБ.Имя) Тогда
			МассивВнешнихПользователей.Удалить(ТекущийНомер);
		Иначе
			Для каждого Роль Из ПользовательИБ.Роли Цикл
				СтараяРольВнешнегоПользователя = СтарыеРолиВнешнихПользователей.Добавить();
				СтараяРольВнешнегоПользователя.ВнешнийПользователь = МассивВнешнихПользователей[ТекущийНомер];
				СтараяРольВнешнегоПользователя.Роль = Роль.Имя;
			КонецЦикла;
		КонецЕсли;
		ТекущийНомер = ТекущийНомер - 1;
	КонецЦикла;
	
	// Подготовка списка ролей отсутствующих в метаданных и которые нужно переустановить.
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СтарыеРолиВнешнихПользователей.ВнешнийПользователь,
		|	СтарыеРолиВнешнихПользователей.Роль
		|ПОМЕСТИТЬ СтарыеРолиВнешнихПользователей
		|ИЗ
		|	&СтарыеРолиВнешнихПользователей КАК СтарыеРолиВнешнихПользователей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВсеДоступныеРоли.Имя
		|ПОМЕСТИТЬ ВсеДоступныеРоли
		|ИЗ
		|	&ВсеДоступныеРоли КАК ВсеДоступныеРоли
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоставГруппПользователей.ГруппаПользователей КАК ГруппаВнешнихПользователей,
		|	СоставГруппПользователей.Пользователь КАК ВнешнийПользователь,
		|	Роли.Роль
		|ПОМЕСТИТЬ ВсеНовыеРолиВнешнихПользователей
		|ИЗ
		|	Справочник.ГруппыВнешнихПользователей.Роли КАК Роли
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставГруппПользователей КАК СоставГруппПользователей
		|		ПО (СоставГруппПользователей.Пользователь В (&ВнешниеПользователи))
		|			И (СоставГруппПользователей.ГруппаПользователей = Роли.Ссылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВсеНовыеРолиВнешнихПользователей.ВнешнийПользователь,
		|	ВсеНовыеРолиВнешнихПользователей.Роль
		|ПОМЕСТИТЬ НовыеРолиВнешнихПользователей
		|ИЗ
		|	ВсеНовыеРолиВнешнихПользователей КАК ВсеНовыеРолиВнешнихПользователей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтарыеРолиВнешнихПользователей.ВнешнийПользователь
		|ПОМЕСТИТЬ ИзмененныеВнешниеПользователи
		|ИЗ
		|	СтарыеРолиВнешнихПользователей КАК СтарыеРолиВнешнихПользователей
		|		ЛЕВОЕ СОЕДИНЕНИЕ НовыеРолиВнешнихПользователей КАК НовыеРолиВнешнихПользователей
		|		ПО (НовыеРолиВнешнихПользователей.ВнешнийПользователь = СтарыеРолиВнешнихПользователей.ВнешнийПользователь)
		|			И (НовыеРолиВнешнихПользователей.Роль = СтарыеРолиВнешнихПользователей.Роль)
		|ГДЕ
		|	НовыеРолиВнешнихПользователей.Роль ЕСТЬ NULL 
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	НовыеРолиВнешнихПользователей.ВнешнийПользователь
		|ИЗ
		|	НовыеРолиВнешнихПользователей КАК НовыеРолиВнешнихПользователей
		|		ЛЕВОЕ СОЕДИНЕНИЕ СтарыеРолиВнешнихПользователей КАК СтарыеРолиВнешнихПользователей
		|		ПО НовыеРолиВнешнихПользователей.ВнешнийПользователь = СтарыеРолиВнешнихПользователей.ВнешнийПользователь
		|			И НовыеРолиВнешнихПользователей.Роль = СтарыеРолиВнешнихПользователей.Роль
		|ГДЕ
		|	СтарыеРолиВнешнихПользователей.Роль ЕСТЬ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВсеНовыеРолиВнешнихПользователей.ГруппаВнешнихПользователей,
		|	ВсеНовыеРолиВнешнихПользователей.ВнешнийПользователь,
		|	ВсеНовыеРолиВнешнихПользователей.Роль
		|ИЗ
		|	ВсеНовыеРолиВнешнихПользователей КАК ВсеНовыеРолиВнешнихПользователей
		|ГДЕ
		|	(НЕ ИСТИНА В
		|				(ВЫБРАТЬ ПЕРВЫЕ 1
		|					ИСТИНА КАК ЗначениеИстина
		|				ИЗ
		|					ВсеДоступныеРоли КАК ВсеДоступныеРоли
		|				ГДЕ
		|					ВсеДоступныеРоли.Имя = ВсеНовыеРолиВнешнихПользователей.Роль))";
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ВсеДоступныеРоли", ПользователиСерверПовтИсп.ВсеРоли());
	Запрос.УстановитьПараметр("СтарыеРолиВнешнихПользователей", СтарыеРолиВнешнихПользователей);
	
	// Регистрация ошибок имен ролей в профилях групп доступа.
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru= 'При обновлении ролей внешнего пользователя ""<%1>"" роль ""<%2>"" группы внешних пользователей ""<%3>"" не найдена в метаданных!'"),
			СокрЛП(Выборка.ВнешнийПользователь.Наименование),
			Выборка.Роль,
			Строка(Выборка.ГруппаВнешнихПользователей));
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Внешние пользователи.Роль не найдена в метаданных'"),
			УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения, РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
		ЕстьОшибки = Истина;
	КонецЦикла;
	
	// Обновление ролей пользователейИБ.
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзмененныеВнешниеПользователиИРоли.ВнешнийПользователь,
		|	ИзмененныеВнешниеПользователиИРоли.Роль
		|ИЗ
		|	(ВЫБРАТЬ
		|		НовыеРолиВнешнихПользователей.ВнешнийПользователь КАК ВнешнийПользователь,
		|		НовыеРолиВнешнихПользователей.Роль КАК Роль
		|	ИЗ
		|		НовыеРолиВнешнихПользователей КАК НовыеРолиВнешнихПользователей
		|	ГДЕ
		|		НовыеРолиВнешнихПользователей.ВнешнийПользователь В
		|				(ВЫБРАТЬ
		|					ИзмененныеВнешниеПользователи.ВнешнийПользователь
		|				ИЗ
		|					ИзмененныеВнешниеПользователи КАК ИзмененныеВнешниеПользователи)
		|	
		|	ОБЪЕДИНИТЬ
		|	
		|	ВЫБРАТЬ
		|		ВнешниеПользователи.Ссылка,
		|		""""
		|	ИЗ
		|		Справочник.ВнешниеПользователи КАК ВнешниеПользователи
		|	ГДЕ
		|		ВнешниеПользователи.Ссылка В
		|				(ВЫБРАТЬ
		|					ИзмененныеВнешниеПользователи.ВнешнийПользователь
		|				ИЗ
		|					ИзмененныеВнешниеПользователи КАК ИзмененныеВнешниеПользователи)) КАК ИзмененныеВнешниеПользователиИРоли
		|
		|УПОРЯДОЧИТЬ ПО
		|	ИзмененныеВнешниеПользователиИРоли.ВнешнийПользователь,
		|	ИзмененныеВнешниеПользователиИРоли.Роль";
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПользовательИБ = Неопределено;
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Роль) Тогда
			ПользовательИБ.Роли.Добавить(Метаданные.Роли[Выборка.Роль]);
            Продолжить;
		КонецЕсли;
		Если ПользовательИБ <> Неопределено Тогда
			ПользовательИБ.Записать();
		КонецЕсли;
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторыПользователейИБ[Выборка.ВнешнийПользователь]);
		ПользовательИБ.Роли.Очистить();
	КонецЦикла;
	Если ПользовательИБ <> Неопределено Тогда
		ПользовательИБ.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Функция ОбъектАвторизацииИспользуется проверяет, что объект информационной базы,
// используется в качестве объекта авторизации внешнего пользователя, кроме текущего (если задан).
//
Функция ОбъектАвторизацииИспользуется(Знач СсылкаНаОбъектАвторизации,
                                      Знач СсылкаНаТекущегоВнешнегоПользователя = Неопределено,
                                      НайденныйВнешнийПользователь = Неопределено,
                                      ЕстьПравоДобавленияВнешнегоПользователя = Ложь) Экспорт
	
	ЕстьПравоДобавленияВнешнегоПользователя = ПравоДоступа("Добавление", Метаданные.Справочники.ВнешниеПользователи);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ Первые 1
	               |	ВнешниеПользователи.Ссылка
	               |ИЗ
	               |	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	               |ГДЕ
	               |	ВнешниеПользователи.ОбъектАвторизации = &СсылкаНаОбъектАвторизации
	               |	И ВнешниеПользователи.Ссылка <> &СсылкаНаТекущегоВнешнегоПользователя";
	Запрос.УстановитьПараметр("СсылкаНаТекущегоВнешнегоПользователя", СсылкаНаТекущегоВнешнегоПользователя);
	Запрос.УстановитьПараметр("СсылкаНаОбъектАвторизации", СсылкаНаОбъектАвторизации);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Если Таблица.Количество() > 0 Тогда
		НайденныйВнешнийПользователь = Таблица[0].Ссылка;
	КонецЕсли;
	
	Возврат Таблица.Количество() > 0;
	
КонецФункции

// Обработчик подписки на событие ОбновитьПредставлениеВнешнегоПользователя
Процедура ОбновитьПредставлениеВнешнегоПользователя(СсылкаНаОбъектАвторизации) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВнешниеПользователи.Ссылка
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	|ГДЕ
	|	ВнешниеПользователи.ОбъектАвторизации = &СсылкаНаОбъектАвторизации
	|	И ВнешниеПользователи.Наименование <> &НовоеПредставлениеОбъектаАвторизации");
	Запрос.УстановитьПараметр("СсылкаНаОбъектАвторизации", СсылкаНаОбъектАвторизации);
	Запрос.УстановитьПараметр("НовоеПредставлениеОбъектаАвторизации", Строка(СсылкаНаОбъектАвторизации));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ВнешнийПользовательОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ВнешнийПользовательОбъект.Наименование = Строка(СсылкаНаОбъектАвторизации);
		ВнешнийПользовательОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления при переходе на новую версию конфигурации БСП
//

// Обработчик обновления при переходе на версию конфигурации 1.0.6.5
// для обновления записей регистра сведений СоставГруппПользователей.
//
Процедура ЗаполнитьСоставГруппВнешнихПользователей() Экспорт
	
	ОбновитьСоставГруппВнешнихПользователей(Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи);
	
КонецПроцедуры

// Обработчик обновления при переходе на версию конфигурации 1.0.6.5
// создает пользователей ИБ из данных Справочник.ВнешниеПользователи
//
Процедура ДляВнешнихПользователейСоздатьПользователейИБ() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Справочники.ВнешниеПользователи.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ЗначениеЗаполнено(Выборка.ИдентификаторПользователяИБ) И
		        ЗначениеЗаполнено(Выборка.ОбъектАвторизации) И
		        ЗначениеЗаполнено(Выборка.Код) Тогда
			
			ВнешнийПользовательОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Попытка
				ПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
				ПользовательИБ.Имя       = Выборка.Код;
				ПользовательИБ.Пароль    = Выборка.УдалитьПароль;
				ПользовательИБ.ПолноеИмя = Строка(Выборка.ОбъектАвторизации);
				ПользовательИБ.Записать();
				ВнешнийПользовательОбъект.ИдентификаторПользователяИБ = ПользовательИБ.УникальныйИдентификатор;
				ВнешнийПользовательОбъект.Записать();
			Исключение
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Внешние пользователи.Ошибка при обновлении информационной базы'"),
				                         УровеньЖурналаРегистрации.Ошибка,
				                         ,
				                         ,
				                         СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				                              НСтр("ru= 'При создании пользователя информационной базы с именем ""%1"" для внешнего пользователя ""%2"" произошла ошибка:
				                                        |%3'"),
				                              Выборка.Код,
				                              Выборка.Наименование,
				                              ОписаниеОшибки()),
				                         РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

