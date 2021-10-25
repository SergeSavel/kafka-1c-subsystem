﻿
Функция ПолучитьОбработку(Шина) Экспорт
	
	Возврат Обработки[Шина.Обработка].Создать();
		
КонецФункции

Функция ЭтоБэкап() Экспорт
		
	// Тут должен находиться алгоритм идентификации ИБ как бекапа.
	Возврат Неопределено;
	
КонецФункции

Функция ГруппаПолучателей() Экспорт
	
	СтрокаСоединения = НРег(СтрокаСоединенияИнформационнойБазы());
	ИмяИБ = СокрЛП(НСтр(СтрокаСоединения, "ref"));
	ИмяКластера = СокрЛП(НСтр(СтрокаСоединения, "srvr"));
	
	Возврат ИмяИБ + "@" + ИмяКластера;
	
КонецФункции

Функция API() Экспорт
	
	Возврат Обработки.КафкаAPI.Создать();
	
КонецФункции

Функция РазрешенОбменБэкапов() Экспорт
	
	Возврат Ложь;
	
КонецФункции