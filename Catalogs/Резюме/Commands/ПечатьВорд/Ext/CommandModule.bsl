﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПечатьРезюме(ПараметрКоманды);
	
	//Макет = Справочники.Резюме.ПолучитьМакет("МакетВорд");
	//Ссылка = ПараметрКоманды.Ссылка;
	//МСВорд = Макет.Получить();
	//
	//Попытка
	//	Документ = МСВорд.Application.Documents(1);
	//	Документ.Activate();
	//	
	//	Замена = Документ.Content.Find;
	//	
	//	ФИО = СокрЛП(Ссылка.Фамилия)+" "+СокрЛП(Ссылка.Имя)+" "+СокрЛП(Ссылка.Отчество);
	//	Замена.Execute("<ПолеФио>",,,,,,,,,ФИО);

	//	МСВорд.Application.Visible = Истина;
	//	МСВорд.Activate();
	//Исключение
	//	МСВорд.Application.Quit();
	//КонецПопытки;

КонецПроцедуры


&НаСервере
Процедура ПечатьРезюме( ПараметрКоманды)
	Справочники.Резюме.ПечатьРезюмеВорд( ПараметрКоманды);
КонецПроцедуры
