﻿////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ СОДЕРЖИТ РЕАЛИЗАЦИЮ МЕХАНИКИ РАБОТЫ С ЭЛЕКТРОННЫМИ СООБЩЕНИЯМИ
// (программные интерфейсы для внешнего использования)
//

// Функция для отправки сообщений. Проверяет корректность заполнения учетной
// записи и вызывает функцию реализующую механику отправки
//
// см. параметры функции ОтправитьСообщение
//
Функция ОтправитьПочтовоеСообщение(знач УчетнаяЗапись,
                                   знач ПараметрыПисьма) Экспорт
	
	Если ТипЗнч(УчетнаяЗапись) <> Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты")
	   ИЛИ НЕ ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ВызватьИсключение НСтр("ru = 'Учетная запись не заполнена или заполнена не правильно'");
	КонецЕсли;
	
	Если ПараметрыПисьма = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не заданы параметры отправки.'");
	КонецЕсли;
	
	Кому = "";
	Если ПараметрыПисьма.Свойство("Кому", Кому) Тогда
		Если ТипЗнч(Кому) = Тип("Строка") Тогда
			ПараметрыПисьма.Кому = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(Кому);
		КонецЕсли;
	Иначе
		ВызватьИсключение НСтр("ru = 'Не указан ни один получатель письма.'");
	КонецЕсли;
	
	Копии = "";
	Если ПараметрыПисьма.Свойство("Копии", Копии) Тогда
		Если ТипЗнч(Копии) = Тип("Строка") Тогда
			ПараметрыПисьма.Копии = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(Копии);
		КонецЕсли;
	КонецЕсли;
	
	СлепыеКопии = "";
	Если ПараметрыПисьма.Свойство("СлепыеКопии", СлепыеКопии) Тогда
		Если ТипЗнч(СлепыеКопии) = Тип("Строка") Тогда
			ПараметрыПисьма.СлепыеКопии = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(СлепыеКопии);
		КонецЕсли;
	КонецЕсли;
	
	АдресОтвета = Неопределено;
	
	// проверяем правильную заполненность АдресаОтвета
	Если ПараметрыПисьма.Свойство("АдресОтвета", АдресОтвета) Тогда
		ПараметрыПисьма.АдресОтвета = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(АдресОтвета);
	КонецЕсли;
	
	Вложения = Неопределено;
	
	Если ПараметрыПисьма.Свойство("Вложения", Вложения) Тогда
		Для Каждого Вложение Из Вложения Цикл
			Если ЭтоАдресВременногоХранилища(Вложение.Значение) Тогда
				Вложения.Вставить(Вложение.Ключ, ПолучитьИзВременногоХранилища(Вложение.Значение));
			КонецЕсли;
		КонецЦикла;
		ПараметрыПисьма.Вложения = Вложения;
	КонецЕсли;
	
	Возврат ОтправитьСообщение(УчетнаяЗапись, ПараметрыПисьма);
	
КонецФункции

// Функция для загрузки сообщений. Проверяет корректность заполнения учетной
// записи и вызывает функцию реализующую механику загрузки сообщений.
// 
// параметры к функции см. в функции ЗагрузитьСообщения
//
Функция ЗагрузитьПочтовыеСообщения(знач УчетнаяЗапись,
                                   знач ПараметрыЗагрузки = Неопределено) Экспорт
	
	Если НЕ УчетнаяЗапись.ИспользоватьДляПолучения Тогда
		ВызватьИсключение НСтр("ru = 'Учетная запись не предназначена для получения сообщений.'");
	КонецЕсли;
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		ПараметрыЗагрузки = Новый Структура;
	КонецЕсли;
	
	Результат = ЗагрузитьСообщения(УчетнаяЗапись, ПараметрыЗагрузки);
	
	Возврат Результат;
	
КонецФункции

// Получает ссылку на учетную запись по виду назначения учетной записи
// Параметры:
// ВидНазначенияУчетнойЗаписи - Перечисления.ВидыНазначенияУчетныхЗаписей -
//                 вид назначения учетной записи
// Возвращаемое значение:
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - ссылка
//                 на описание учетной записи
//
Функция ПолучитьСистемнуюУчетнуюЗапись() Экспорт
	
	Возврат Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	
КонецФункции

// Проверяет, что предопределенная системная учетная запись электронной почты
// доступна для использования
//
Функция ПроверитьСистемнаяУчетнаяЗаписьДоступна() Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УчетныеЗаписиЭлектроннойПочты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
		|ГДЕ
		|	УчетныеЗаписиЭлектроннойПочты.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.Параметры.Вставить("Ссылка", ПолучитьСистемнуюУчетнуюЗапись());
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Получить доступные учетные записи электронной почты
// Параметры:
// ДляОтправки - Булево - Если установлено Истина, то будут выбирать только записи, с которых можно отправлять почту
// ДляПолучения   - Булево - Если установлено Истина, то будут выбирать только записи, по которым можно получать почту
// ВключатьСистемнуюУчетнуюЗапись - Булево - включать системную учетную запись, если доступна
//
// Возвращаемое значение:
// ДоступныеУчетныеЗаписи - ТаблицаЗначений - С колонками:
//    Ссылка       - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - Ссылка на учетную запись
//    Наименование - Строка - Наименование учетной записи
//    Адрес        - Строка - Адрес электронной почты
//
Функция ПолучитьДоступныеУчетныеЗаписи(знач ДляОтправки = Неопределено,
										знач ДляПолучения  = Неопределено,
										знач ВключатьСистемнуюУчетнуюЗапись = Истина) Экспорт
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УчетныеЗаписиЭлектроннойПочты.Ссылка				КАК Ссылка,
		|	УчетныеЗаписиЭлектроннойПочты.Наименование			КАК Наименование,
		|	УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты КАК Адрес
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
		|ГДЕ";
	
	Если ДляОтправки <> Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки = &ДляОтправки";
	КонецЕсли;
	
	Если ДляПолучения <> Неопределено Тогда
		Если ДляОтправки <> Неопределено Тогда
			ТекстЗапроса = ТекстЗапроса + "
			| И";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + "
		|	УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляПолучения = &ДляПолучения";
	КонецЕсли;

	Если НЕ ВключатьСистемнуюУчетнуюЗапись Тогда
		ТекстЗапроса =ТекстЗапроса + "
		|	И УчетныеЗаписиЭлектроннойПочты.Ссылка <> Значение(Справочник.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты)";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.Параметры.Вставить("ДляОтправки", ДляОтправки);
	Запрос.Параметры.Вставить("ДляПолучения", ДляПолучения);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функция отправления - непосредственная реализация механики отправления
// электронного сообщения
//
// Функция, реализующая механику отправки сообщения электронной почты
//
// Параметры:
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - ссылка на
//                 учетную запись электронной почты
// ПараметрыПисьма - структура - содержит всю необходимую информацию о письме:
//                   содержит следующие ключи:
//    Кому*      - Массив структур, строка - интернет адрес получателя письма
//                 Адрес         - строка - почтовый адрес
//                 Представление - строка - имя адресата
//    Копии      - массив структур, строка - интернет адреса получателей письма
//                 используется при формировании письма для поля копий
//                 в случае массива структур, формат каждой структуры:
//                 Адрес         - строка - почтовый адрес (должно быть обязательно заполнено)
//                 Представление - строка - имя адресата
//    СлепыеКопии - массив структур, строка - интернет адреса получателей письма
//                 используется при формировании письма для поля скрытых копий
//                 в случае массива структур, формат каждой структуры:
//                 Адрес         - строка - почтовый адрес (должно быть обязательно заполнено)
//                 Представление - строка - имя адресата
//
//    Тема*      - строка - тема почтового сообщения
//    Тело*      - тело почтового сообщения (простой текст в кодировке win-1251)
//    Вложения   - соответствие
//                 ключ     - наименованиеВложения - строка - наименование вложения
//                 значение - ДвоичныеДанные - данные вложения
//
// дополнительные ключи структуры, которые могут использоваться:
//    АдресОтвета - соответствие - см. такие же поля как и кому
//    Пароль      - строка - пароль для доступа учетной записи
//    ТипТекста   - Строка / Перечисление.ТипыТекстовЭлектронныхПисем/ТипТекстаПочтовогоСообщения  определяет тип переданного теста
//                  допустимые значения:
//                  HTML/ТипыТекстовЭлектронныхПисем.HTML - текст почтового сообщения в формате HTML
//                  ПростойТекст/ТипыТекстовЭлектронныхПисем.ПростойТекст - простой текст почтового сообщения. Отображается "как есть" (значение по умолчанию)
//                  РазмеченныйТекст/ТипыТекстовЭлектронныхПисем.РазмеченныйТекст - текст почтового сообщения в формате Rich Text
//
//    прим.: параметры письма помеченные символом '*' являются обязательными
//           т.е. к началу работы функции считается что они уже заполнены
//
// Возвращаемое значение:
// Строка - идентификатор отправленного почтового сообщения на smtp сервере
//
// ПРИМЕЧАНИЕ: функция может вызвать исключение, которое требуется обработать
//
Функция ОтправитьСообщение(знач УчетнаяЗапись,
                           знач ПараметрыПисьма) Экспорт
	
	// Объявление переменных перед первым использованием в качестве
	// параметра метода Свойство структуры ПараметрыПисьма.
	// Переменные содержат значения переданных в функцию параметров.
	Перем Кому, Тема, Тело, Вложения, АдресОтвета, ТипТекста, Копии, СлепыеКопии;
	
	Если Не ПараметрыПисьма.Свойство("Тема", Тема) Тогда
		Тема = "";
	КонецЕсли;
	
	Если Не ПараметрыПисьма.Свойство("Тело", Тело) Тогда
		Тело = "";
	КонецЕсли;
	
	Кому = ПараметрыПисьма.Кому;
	
	Если ТипЗнч(Кому) = Тип("Строка") Тогда
		Кому = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(Кому);
	КонецЕсли;
	
	ПараметрыПисьма.Свойство("Вложения", Вложения);
	
	Письмо = Новый ИнтернетПочтовоеСообщение;
	Письмо.Тема = Тема;
	
	// формируем адрес получателя	
	Для Каждого ПочтовыйАдресПолучателя Из Кому Цикл
		Получатель = Письмо.Получатели.Добавить(ПочтовыйАдресПолучателя.Адрес);
		Получатель.ОтображаемоеИмя = ПочтовыйАдресПолучателя.Представление;
	КонецЦикла;
	
	Если ПараметрыПисьма.Свойство("Копии", Копии) Тогда
		// формируем адрес получателя поля Копии
		Для Каждого ПочтовыйАдресПолучателяКопии Из Копии Цикл
			Получатель = Письмо.Копии.Добавить(ПочтовыйАдресПолучателяКопии.Адрес);
			Получатель.ОтображаемоеИмя = ПочтовыйАдресПолучателяКопии.Представление;
		КонецЦикла;
	КонецЕсли;
	
	Если ПараметрыПисьма.Свойство("СлепыеКопии", СлепыеКопии) Тогда
		// формируем адрес получателя поля Копии
		Для Каждого ПочтовыйАдресПолучателяСлепыеКопии Из СлепыеКопии Цикл
			Получатель = Письмо.СлепыеКопии.Добавить(ПочтовыйАдресПолучателяСлепыеКопии.Адрес);
			Получатель.ОтображаемоеИмя = ПочтовыйАдресПолучателяСлепыеКопии.Представление;
		КонецЦикла;
	КонецЕсли;
	
	// формируем адрес ответа, если необходимо
	Если ПараметрыПисьма.Свойство("АдресОтвета", АдресОтвета) Тогда
		Для Каждого ПочтовыйАдресОтвета Из АдресОтвета Цикл
			ПочтовыйАдресОбратный = Письмо.ОбратныйАдрес.Добавить(ПочтовыйАдресОтвета.Адрес);
			ПочтовыйАдресОбратный.ОтображаемоеИмя = ПочтовыйАдресОтвета.Представление;
		КонецЦикла;
	КонецЕсли;
	
	// добавляем к письму имя отправителя
	Письмо.ИмяОтправителя              = УчетнаяЗапись.ИмяПользователя;
	Письмо.Отправитель.ОтображаемоеИмя = УчетнаяЗапись.ИмяПользователя;
	Письмо.Отправитель.Адрес           = УчетнаяЗапись.АдресЭлектроннойПочты;
	
	// добавляем вложения к письму
	Если Вложения <> Неопределено Тогда
		Для Каждого ЭлементВложение Из Вложения Цикл
			Письмо.Вложения.Добавить(ЭлементВложение.Значение, ЭлементВложение.Ключ);
		КонецЦикла;
	КонецЕсли;

	// Установим строку с идентификаторами оснований
	Если ПараметрыПисьма.Свойство("ИдентификаторыОснований") Тогда
		Письмо.УстановитьПолеЗаголовка("References", ПараметрыПисьма.ИдентификаторыОснований);
	КонецЕсли;
	
	// добавляем текст
	Текст = Письмо.Тексты.Добавить(Тело);
	Если ПараметрыПисьма.Свойство("ТипТекста", ТипТекста) Тогда
		Если ТипЗнч(ТипТекста) = Тип("Строка") Тогда
			Если      ТипТекста = "HTML" Тогда
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.HTML;
			ИначеЕсли ТипТекста = "RichText" Тогда
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.РазмеченныйТекст;
			Иначе
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
			КонецЕсли;
		ИначеЕсли ТипЗнч(ТипТекста) = Тип("ПеречислениеСсылка.ТипыТекстовЭлектронныхПисем") Тогда
			Если      ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML
				  ИЛИ ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTMLСКартинками Тогда
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.HTML;
			ИначеЕсли ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.РазмеченныйТекст Тогда
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.РазмеченныйТекст;
			Иначе
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
			КонецЕсли;
		Иначе
			Текст.ТипТекста = ТипТекста;
		КонецЕсли;
	Иначе
		Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	КонецЕсли;

	// Зададим важность
	Важность = Неопределено;
	Если ПараметрыПисьма.Свойство("Важность", Важность) Тогда
		Письмо.Важность = Важность;
	КонецЕсли;
	
	// Зададим кодировку
	Кодировка = Неопределено;
	Если ПараметрыПисьма.Свойство("Кодировка", Кодировка) Тогда
		Письмо.Кодировка = Кодировка;
	КонецЕсли;

	Если ПараметрыПисьма.Свойство("Пароль") Тогда
		Профиль = СформироватьИнтернетПрофиль(УчетнаяЗапись, ПараметрыПисьма.Пароль);
	Иначе
		Профиль = СформироватьИнтернетПрофиль(УчетнаяЗапись);
	КонецЕсли;
	
	Соединение = Новый ИнтернетПочта;
	
	Соединение.Подключиться(Профиль);
	
	Соединение.Послать(Письмо);
	
	Соединение.Отключиться();
	
	Возврат Письмо.ИдентификаторСообщения;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функция просмотра почты - непосредственная реализация механики отправления
// электронного сообщения
//
// Функция, реализующая механику загрузки сообщений с сервера электронной почты
// для указанной учетной записи электронной почты
//
// Параметры:
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - ссылка на
//                 учетную запись электронной почты
//
// ПараметрыЗагрузки - структура
// ключ "Колонки" - массив - массив строк названий колонок
//                  названия колонок должны соответствовать полям объекта
//                  ИнтернетПочтовоеСообщение 
// ключ "РежимТестирования" - булево - если Истина то вызов сделан в режиме тестирования
//                            учетной записи - при этом выборка писем происходит,
//                            но в возвращаемом значении они не попадают; по умолчанию
//                            режим тестирования отключен
// ключ "ПолучениеЗаголовков" - булево - если Истина то в возвращаемом наборе есть только
//                                       заголовки писем
// ЗаголовкиИдентификаторы - массив - заголовки или идентификаторы сообщений, полные
//                                    сообщения по которым требуется получить
// ПриводитьСообщенияКТипу - Булево - возвращать набор полученных почтовых сообщений
//                                    в виде таблицы значений, с простыми типами
//                                    по умолчанию Истина
//
// ключ "Пароль" - строка - пароль для доступа к POP3
//
// Возвращаемое значение:
// НаборСообщений*- таблица значений, содержит адаптированный вариант списка сообщений на сервере
//                 Колонки таблицы значений (по умолчанию):
//                 Важность, Вложения**, ДатаОтправления, ДатаПолучения, Заголовок, ИмяОтправителя,
//                 Идентификатор, Копии, Обратный адрес, Отправитель, Получатели, Размер, Тексты,
//                 Кодировка, СпособКодированияНеASCIIСимволов, Частичное
//                 заполняется если статус Истина
//
// Прим. * - в режиме тестирования не участвует в формировании возвращаемого значения
// Прим. ** - в случае, если вложениями являются другие почтовые сообщения,
//            они сами не возвращаются но возвращаются их вложения - двоичные
//            данные и их тексты в виде двоичных данных, рекурсивно
//
Функция ЗагрузитьСообщения(знач УчетнаяЗапись,
                           знач ПараметрыЗагрузки = Неопределено)
	
	// Используется для проверки возможности входа на почтовый ящик
	Перем РежимТестирования;
	
	// Получать только заголовки писем
	Перем ПолучениеЗаголовков;
	
	// Приводить почтовые сообщения к простому типу;
	Перем ПриводитьСообщенияКТипу;
	
	// Заголовки или идентификаторы писем, полные сообщения по которым требуется получить
	Перем ЗаголовкиИдентификаторы;
	
	Если ПараметрыЗагрузки.Свойство("РежимТестирования") Тогда
		РежимТестирования = ПараметрыЗагрузки.РежимТестирования;
	Иначе
		РежимТестирования = Ложь;
	КонецЕсли;
	
	Если ПараметрыЗагрузки.Свойство("ПолучениеЗаголовков") Тогда
		ПолучениеЗаголовков = ПараметрыЗагрузки.ПолучениеЗаголовков;
	Иначе
		ПолучениеЗаголовков = Ложь;
	КонецЕсли;
	
	Если ПараметрыЗагрузки.Свойство("Пароль") Тогда
		Профиль = СформироватьИнтернетПрофиль(УчетнаяЗапись, ПараметрыЗагрузки.Пароль);
	Иначе
		Профиль = СформироватьИнтернетПрофиль(УчетнаяЗапись);
	КонецЕсли;
	
	Если ПараметрыЗагрузки.Свойство("ЗаголовкиИдентификаторы") Тогда
		ЗаголовкиИдентификаторы = ПараметрыЗагрузки.ЗаголовкиИдентификаторы;
	Иначе
		ЗаголовкиИдентификаторы = Новый Массив;
	КонецЕсли;
	
	НаборСообщенийДляУдаления = Новый Массив;
	
	Соединение = Новый ИнтернетПочта;
	
	Соединение.Подключиться(Профиль);
	
	Если РежимТестирования ИЛИ ПолучениеЗаголовков Тогда
		
		НаборПисем = Соединение.ПолучитьЗаголовки();
		
	Иначе
		
		Если УчетнаяЗапись.ОставлятьКопииСообщенийНаСервере Тогда
			
			Если ЗаголовкиИдентификаторы.Количество() =0
			   И УчетнаяЗапись.ПериодХраненияСообщенийНаСервере > 0 Тогда
				
				Заголовки = Соединение.ПолучитьЗаголовки();
				
				НаборСообщенийДляУдаления = Новый Массив;
				
				Для Каждого ЭлементЗаголовок Из Заголовки Цикл
					ТекущаяДата = ТекущаяДата();
					РазницаДат = (ТекущаяДата - ЭлементЗаголовок.ДатаОтправления) / (3600*24);
					Если РазницаДат >= УчетнаяЗапись.ПериодХраненияСообщенийНаСервере Тогда
						НаборСообщенийДляУдаления.Добавить(ЭлементЗаголовок);
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
			
			АвтоматическиУдалятьСообщенияПриВыбореССервера = Ложь;
			
		Иначе
			
			АвтоматическиУдалятьСообщенияПриВыбореССервера = Истина;
			
		КонецЕсли;
		
		НаборПисем = Соединение.Выбрать(АвтоматическиУдалятьСообщенияПриВыбореССервера, ЗаголовкиИдентификаторы);
		
		Если НаборСообщенийДляУдаления.Количество() > 0 Тогда
			Соединение.УдалитьСообщения(НаборСообщенийДляУдаления);
		КонецЕсли;
		
	КонецЕсли;
	
	Соединение.Отключиться();
	
	Если РежимТестирования Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ПараметрыЗагрузки.Свойство("ПриводитьСообщенияКТипу") Тогда
		ПриводитьСообщенияКТипу = ПараметрыЗагрузки.ПриводитьСообщенияКТипу;
	Иначе
		ПриводитьСообщенияКТипу = Истина;
	КонецЕсли;
	
	Если ПриводитьСообщенияКТипу Тогда
		Если ПараметрыЗагрузки.Свойство("Колонки") Тогда
			НаборСообщений = ПолучитьАдаптированныйНаборПисем(НаборПисем, ПараметрыЗагрузки.Колонки);
		Иначе
			НаборСообщений = ПолучитьАдаптированныйНаборПисем(НаборПисем);
		КонецЕсли;
	КонецЕсли;
	
	Возврат НаборСообщений;
	
КонецФункции

// Устанавливает соединение с сервером электронной почты
// Параметры:
// Профиль       - ИнтернетПочтовыйПрофиль - профиль учетной записи электронной
//                 почты, через который необходимо установить соединение
//
// Возвращаемое значение:
// Соединение (тип ИнтернетПочта)
//
Функция УстановитьСоединениеССерверомЭлектроннойПочты(Профиль) Экспорт
	
	Соединение = Новый ИнтернетПочта;
	Соединение.Подключиться(Профиль);
	
	Возврат Соединение;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Блок системных и вспомогательных функций подсистемы
//

// По переданной ссылке на учетную запись формирует профиль почтового соединения
//
// Параметры
// УчетнаяЗапись - СправочникСсылка.УчетнаяЗаписьЭлектроннойПочты - 
//                 параметры профиля в виде соответствия
//
// Возвращаемое значение
// Почтовый профиль (тип ИнтернетПочтовыйПрофиль)
//
Функция СформироватьИнтернетПрофиль(знач УчетнаяЗапись,
                                    знач Пароль = Неопределено,
                                    знач ФормироватьSMTPПрофиль = Истина,
                                    знач ФормироватьPOP3Профиль = Истина) Экспорт
	
	Профиль = Новый ИнтернетПочтовыйПрофиль;
	
	Профиль.Пользователь = УчетнаяЗапись.Пользователь;
	
	Профиль.ВремяОжидания = УчетнаяЗапись.ВремяОжидания;
	
	Если ЗначениеЗаполнено(Пароль) Тогда
		Профиль.Пароль = Пароль;
	Иначе
		Профиль.Пароль = УчетнаяЗапись.Пароль;
	КонецЕсли;
	
	Если ФормироватьSMTPПрофиль Тогда
		Профиль.АдресСервераSMTP = УчетнаяЗапись.СерверИсходящейПочтыSMTP;
		Профиль.ПортSMTP         = УчетнаяЗапись.ПортSMTP;
		
		Если      УчетнаяЗапись.SMTPАутентификация = Перечисления.ВариантыSMTPАутентификации.АналогичноPOP3 Тогда
			Профиль.АутентификацияSMTP = СпособSMTPАутентификации.ПоУмолчанию;
			Профиль.ПользовательSMTP   = УчетнаяЗапись.Пользователь;
			Профиль.ПарольSMTP         = УчетнаяЗапись.Пароль;
		ИначеЕсли УчетнаяЗапись.SMTPАутентификация = Перечисления.ВариантыSMTPАутентификации.ЗадаетсяПараметрами Тогда
			
			Если      УчетнаяЗапись.СпособSMTPАутентификации = Перечисления.СпособыSMTPАутентификации.CramMD5 Тогда
				Профиль.АутентификацияSMTP = СпособSMTPАутентификации.CramMD5;
			ИначеЕсли УчетнаяЗапись.СпособSMTPАутентификации = Перечисления.СпособыSMTPАутентификации.Login Тогда
				Профиль.АутентификацияSMTP = СпособSMTPАутентификации.Login;
			ИначеЕсли УчетнаяЗапись.СпособSMTPАутентификации = Перечисления.СпособыSMTPАутентификации.Plain Тогда
				Профиль.АутентификацияSMTP = СпособSMTPАутентификации.Plain;
			ИначеЕсли УчетнаяЗапись.СпособSMTPАутентификации = Перечисления.СпособыSMTPАутентификации.БезАутентификации Тогда
				Профиль.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
			Иначе
				Профиль.АутентификацияSMTP = СпособSMTPАутентификации.ПоУмолчанию;
			КонецЕсли;
			
			Профиль.ПользовательSMTP = УчетнаяЗапись.ПользовательSMTP;
			Профиль.ПарольSMTP       = УчетнаяЗапись.ПарольSMTP;
			
		ИначеЕсли УчетнаяЗапись.SMTPАутентификация = Перечисления.ВариантыSMTPАутентификации.POP3ПередSMTP Тогда
			Профиль.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
			Профиль.POP3ПередSMTP = Истина;
		Иначе
			Профиль.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
		КонецЕсли;
	КонецЕсли;
	
	Если ФормироватьPOP3Профиль Тогда
		Профиль.АдресСервераPOP3 = УчетнаяЗапись.СерверВходящейПочтыPOP3;
		Профиль.ПортPOP3         = УчетнаяЗапись.ПортPOP3;
		
		Если      УчетнаяЗапись.СпособPOP3Аутентификации = Перечисления.СпособыPOP3Аутентификации.APOP Тогда
			Профиль.АутентификацияPOP3 = СпособPOP3Аутентификации.APOP;
		ИначеЕсли УчетнаяЗапись.СпособPOP3Аутентификации = Перечисления.СпособыPOP3Аутентификации.CramMD5 Тогда
			Профиль.АутентификацияPOP3 = СпособPOP3Аутентификации.CramMD5;
		Иначе
			Профиль.АутентификацияPOP3 = СпособPOP3Аутентификации.Обычная;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Профиль;
	
КонецФункции

// Функция записывает адаптированный набор писем по переданным колонкам.
// Значения колонок, типы которых не поддерживаются для оперирования на клиенте
// преобразуются к строковому виду.
//
Функция ПолучитьАдаптированныйНаборПисем(знач НаборПисем, знач Колонки = Неопределено)
	
	Результат = СоздатьАдаптированноеОписаниеПисьма(Колонки);
	
	Для Каждого ПочтовоеСообщение Из НаборПисем Цикл
		НоваяСтрока = Результат.Добавить();
		
		Для Каждого НаименованиеКолонки Из Колонки Цикл
			
			Значение = ПочтовоеСообщение[НаименованиеКолонки];
			
			Если ТипЗнч(Значение) = Тип("ИнтернетПочтовыеАдреса") Тогда
				значение_итог = "";
				Для Каждого ОчереднойАдрес  Из Значение Цикл
					значение_вр =  ОчереднойАдрес.Адрес;
					Если ЗначениеЗаполнено(ОчереднойАдрес.ОтображаемоеИмя) Тогда
						значение_вр = ОчереднойАдрес.ОтображаемоеИмя + " <" + значение_вр + ">";
					КонецЕсли;
					Если ЗначениеЗаполнено(значение_вр) Тогда
						значение_вр = значение_вр + "; "
					КонецЕсли;
					значение_итог = значение_итог + значение_вр;
				КонецЦикла;
				
				Если ЗначениеЗаполнено(значение_итог) Тогда
					значение_итог = сред(значение_итог, 1, СтрДлина(значение_итог)-2)
				КонецЕсли;
				
				значение = значение_итог;
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("ИнтернетПочтовыйАдрес") Тогда
				значение_вр =  Значение.Адрес;
				Если ЗначениеЗаполнено(Значение.ОтображаемоеИмя) Тогда
					значение_вр = Значение.ОтображаемоеИмя + " <" + значение_вр + ">";
				КонецЕсли;
				значение = значение_вр;
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("ВажностьИнтернетПочтовогоСообщения") Тогда
				значение = Строка(Значение);
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("СпособКодированияНеASCIIСимволовИнтернетПочтовогоСообщения") Тогда
				значение = Строка(Значение);
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("ИнтернетПочтовыеВложения") Тогда
				значение_соотв = Новый Соответствие;
			
				Для Каждого ОчередноеВложение Из Значение Цикл
					ИмяВложения = ОчередноеВложение.Имя;
					Если ТипЗнч(ОчередноеВложение.Данные) = Тип("ДвоичныеДанные") Тогда
						значение_соотв.Вставить(ИмяВложения, ОчередноеВложение.Данные);
					Иначе
						ЗаполнитьВложенныеВложения(значение_соотв, ИмяВложения, ОчередноеВложение.Данные);
					КонецЕсли;
				КонецЦикла;
				
				значение = значение_соотв;
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("ИнтернетТекстыПочтовогоСообщения") Тогда
				значение_масс = Новый Массив;
				Для Каждого ОчереднойТекст Из Значение Цикл
					значение_соотв = Новый Соответствие;
					
					значение_соотв.Вставить("Данные", ОчереднойТекст.Данные);
					значение_соотв.Вставить("Кодировка", ОчереднойТекст.Кодировка);
					значение_соотв.Вставить("Текст", ОчереднойТекст.Текст);
					значение_соотв.Вставить("ТипТекста", Строка(ОчереднойТекст.ТипТекста));
					
					значение_масс.Добавить(значение_соотв);
				КонецЦикла;
				значение = значение_масс;
			КонецЕсли;
			
			НоваяСтрока[НаименованиеКолонки] = Значение;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьВложенныеВложения(Вложения, ИмяВложения, ИнтернетПочтовоеСообщение)
	
	Для Каждого ИнтернетПочтовоеВложение Из ИнтернетПочтовоеСообщение.Вложения Цикл
		ИмяВложения = ИнтернетПочтовоеВложение.Имя;
		Если ТипЗнч(ИнтернетПочтовоеВложение.Данные) = Тип("ДвоичныеДанные") Тогда
			Вложения.Вставить(ИмяВложения, ИнтернетПочтовоеВложение.Данные);
		Иначе
			ЗаполнитьВложенныеВложения(Вложения, ИмяВложения, ИнтернетПочтовоеВложение.Данные);
		КонецЕсли;
	КонецЦикла;
	
	Индекс = 0;
	
	Для Каждого ИнтернетТекстыПочтовогоСообщения Из ИнтернетПочтовоеСообщение.Тексты Цикл
		
		Если      ИнтернетТекстыПочтовогоСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.HTML Тогда
			Расширение = "html";
		ИначеЕсли ИнтернетТекстыПочтовогоСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст Тогда
			Расширение = "txt";
		Иначе
			Расширение = "rtf";
		КонецЕсли;
		ИмяТекстаВложения = "";
		Пока ИмяТекстаВложения = "" Или Вложения.Получить(ИмяТекстаВложения) <> Неопределено Цикл
			Индекс = Индекс + 1;
			ИмяТекстаВложения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 - (%2).%3", ИмяВложения, Индекс, Расширение);
		КонецЦикла;
		Вложения.Вставить(ИмяТекстаВложения, ИнтернетТекстыПочтовогоСообщения.Данные);
	КонецЦикла;
	
КонецПроцедуры

// Функция подготавливает таблицу, в которой впоследствии будут
// храниться сообщения с почтового сервера.
// 
// Параметры
// Колонки - строка - список полей письма, через запятую, которые должны
//                    быть записаны в таблицу. Параметр меняет тип на массив.
// Возвращаемое значение
// ТаблицаЗначений - пустая таблица значений с колонками
//
Функция СоздатьАдаптированноеОписаниеПисьма(Колонки = Неопределено)
	
	Если Колонки <> Неопределено
	   И ТипЗнч(Колонки) = Тип("Строка") Тогда
		Колонки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Колонки, ",");
		Для Индекс = 0 По Колонки.Количество()-1 Цикл
			Колонки[Индекс] = СокрЛП(Колонки[Индекс]);
		КонецЦикла;
	КонецЕсли;
	
	МассивКолонокПоУмолчанию = Новый Массив;
	МассивКолонокПоУмолчанию.Добавить("Важность");
	МассивКолонокПоУмолчанию.Добавить("Вложения");
	МассивКолонокПоУмолчанию.Добавить("ДатаОтправления");
	МассивКолонокПоУмолчанию.Добавить("ДатаПолучения");
	МассивКолонокПоУмолчанию.Добавить("Заголовок");
	МассивКолонокПоУмолчанию.Добавить("ИмяОтправителя");
	МассивКолонокПоУмолчанию.Добавить("Идентификатор");
	МассивКолонокПоУмолчанию.Добавить("Копии");
	МассивКолонокПоУмолчанию.Добавить("ОбратныйАдрес");
	МассивКолонокПоУмолчанию.Добавить("Отправитель");
	МассивКолонокПоУмолчанию.Добавить("Получатели");
	МассивКолонокПоУмолчанию.Добавить("Размер");
	МассивКолонокПоУмолчанию.Добавить("Тема");
	МассивКолонокПоУмолчанию.Добавить("Тексты");
	МассивКолонокПоУмолчанию.Добавить("Кодировка");
	МассивКолонокПоУмолчанию.Добавить("СпособКодированияНеASCIIСимволов");
	МассивКолонокПоУмолчанию.Добавить("Частичное");
	
	Если Колонки = Неопределено Тогда
		Колонки = МассивКолонокПоУмолчанию;
	КонецЕсли;
	
	Результат = Новый ТаблицаЗначений;
	
	Для Каждого НаименованиеКолонки Из Колонки Цикл
		Результат.Колонки.Добавить(НаименованиеКолонки);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Блок функций первоначального заполнения и обновления ИБ
//

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.0.0";
	Обработчик.Процедура = "ЭлектроннаяПочта.ЗаполнитьСистемнуюУчетнуюЗапись";
	
КонецПроцедуры

// Выполняет заполнение системной учетной записи значениями по умолчанию
//
Процедура ЗаполнитьСистемнуюУчетнуюЗапись() Экспорт
	
	УчетнаяЗапись = ПолучитьСистемнуюУчетнуюЗапись().ПолучитьОбъект();
	УчетнаяЗапись.Заблокировать();
	УчетнаяЗапись.ЗаполнитьОбъектЗначениямиПоУмолчанию();
	УчетнаяЗапись.Записать();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
//
// Блок функций для проверки учетной записи
//

// Возвращает указан ли в учетной записи пароль или нет
//
Функция ПарольЗадан(УчетнаяЗапись) Экспорт
	
	Возврат ЗначениеЗаполнено(УчетнаяЗапись.Пароль);
	
КонецФункции

// Служебная функция используется для проверки учетной записи электронной почты.
//
Процедура ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, ПарольПараметр, СообщениеОбОшибке, ДополнительноеСообщение) Экспорт
	
	СообщениеОбОшибке = "";
	ДополнительноеСообщение = "";
	
	Если УчетнаяЗапись.ИспользоватьДляОтправки Тогда
		Попытка
			ПроверитьВозможностьОтправкиТестовогоСообщения(УчетнаяЗапись, ПарольПараметр);
		Исключение
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = 'Ошибка при отправке сообщения: %1'"),
									КраткоеПредставлениеОшибки(ИнформацияОбОшибке()) );
		КонецПопытки;
	Иначе
		ДополнительноеСообщение = Символы.ПС + НСтр("ru = 'Прим. учетная запись не используется для отправки электронных сообщений.'");
	КонецЕсли;
	
	Если УчетнаяЗапись.ИспользоватьДляПолучения Тогда
		Попытка
			ПроверитьВходНаСерверВходящейЭлектроннойПочты(УчетнаяЗапись, ПарольПараметр);
		Исключение
			Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
				СообщениеОбОшибке = СообщениеОбОшибке + Символы.ПС;
			КонецЕсли;
			
			СообщениеОбОшибке = СообщениеОбОшибке
								+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = 'Ошибка доступа к серверу входящих сообщений: %1'"),
										КраткоеПредставлениеОшибки(ИнформацияОбОшибке()) );
		КонецПопытки;
	Иначе
		ДополнительноеСообщение = ДополнительноеСообщение
								+ Символы.ПС
								+ НСтр("ru = 'Прим. учетная запись не используется для получения электронных сообщений.'");
	КонецЕсли;
	
КонецПроцедуры

// Процедура проверяющая возможность отправления почтового сообщения через
// учетную запись
//
// Параметры
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись,
//                 которую необходимо проверить
//
// Возвращаемое значение
// структура 
// ключ "статус" - булево, если Истина - успешно вошли на сервер pop3
//                 если Ложь - ошибка при входе на сервер pop3
// ключ "СообщениеОбОшибке" - строка - если статус Ложь - содержит сообщение об ошибке
//
Процедура ПроверитьВозможностьОтправкиТестовогоСообщения(знач УчетнаяЗапись,
														знач Пароль = Неопределено)
	
	ПараметрыПисьма = Новый Структура;
	
	ПараметрыПисьма.Вставить("Тема", НСтр("ru = 'Тестовое сообщение 1С:Предприятие'"));
	ПараметрыПисьма.Вставить("Тело", НСтр("ru = 'Это сообщение отправлено подсистемой электронной почты 1С:Предприятие'"));
	ПараметрыПисьма.Вставить("Кому", УчетнаяЗапись.АдресЭлектроннойПочты);
	Если Пароль <> Неопределено Тогда
		ПараметрыПисьма.Вставить("Пароль", Пароль);
	КонецЕсли;
	
	ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	
КонецПроцедуры

// Процедура проверяющая возможность получения почтового сообщения через
// учетную запись
//
// Параметры
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись,
//                 которую необходимо проверить
//
// Возвращаемое значение
// структура 
// ключ "статус" - булево, если Истина - успешно вошли на сервер pop3
//                 если Ложь - ошибка при входе на сервер pop3
// ключ "СообщениеОбОшибке" - строка - если статус Ложь - содержит сообщение об ошибке
//
Процедура ПроверитьВходНаСерверВходящейЭлектроннойПочты(знач УчетнаяЗапись,
														знач Пароль = Неопределено)
	
	ПараметрыЗагрузки = Новый Структура("РежимТестирования", Истина);
	
	Если Пароль <> Неопределено Тогда
		ПараметрыЗагрузки.Вставить("Пароль", Пароль);
	КонецЕсли;
	
	ЗагрузитьПочтовыеСообщения(УчетнаяЗапись, ПараметрыЗагрузки);
	
КонецПроцедуры
