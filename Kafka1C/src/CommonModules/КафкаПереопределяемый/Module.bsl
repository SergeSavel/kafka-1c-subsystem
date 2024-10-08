// Copyright 2023 Савельев Сергей Владимирович
//
// Лицензировано согласно Лицензии Apache, Версия 2.0 ("Лицензия");
// вы можете использовать этот файл только в соответствии с Лицензией.
// Вы можете найти копию Лицензии по адресу
//
// http://www.apache.org/licenses/LICENSE-2.0.
//
// За исключением случаев, когда это регламентировано существующим
// законодательством, или если это не оговорено в письменном соглашении,
// программное обеспечение, распространяемое на условиях данной Лицензии,
// предоставляется "КАК ЕСТЬ", и любые явные или неявные ГАРАНТИИ ОТВЕРГАЮТСЯ.
// Информацию об основных правах и ограничениях, применяемых к определенному
// языку согласно Лицензии, вы можете найти в данной Лицензии.

Функция ЭтоБэкап() Экспорт
		
	Возврат Ложь;
	
КонецФункции

Функция РазрешенОбменБэкапов() Экспорт
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьОбработку(Шина) Экспорт
	
	Возврат Обработки[Шина.Обработка].Создать();
		
КонецФункции

Функция ГруппаПолучателей() Экспорт
	
	Возврат ИдентификаторИнформационнойБазы();
	
КонецФункции

Функция Адаптер() Экспорт
	
	Возврат Обработки.КафкаАдаптер.Создать();
	
КонецФункции

Функция ПользовательПоУмолчанию() Экспорт
	
	Возврат ИдентификаторИнформационнойБазы();
	
КонецФункции

Функция ИдентификаторИнформационнойБазы() Экспорт
	
	СтрокаСоединения = НРег(КафкаПовтИсп.СтрокаСоединенияИБ());
	
	ИмяИБ = СокрЛП(НСтр(СтрокаСоединения, "ref"));
	ИмяКластера = СокрЛП(НСтр(СтрокаСоединения, "srvr"));
	
	Если ИмяКластера = "" Тогда
		Возврат ИмяИБ;
	Иначе
		Возврат ИмяИБ + "@" + ИмяКластера;
	КонецЕсли;
	
КонецФункции

Функция ИмяИнформационнойБазы() Экспорт
	
	СтрокаСоединения = НРег(КафкаПовтИсп.СтрокаСоединенияИБ());
	Возврат СокрЛП(НСтр(СтрокаСоединения, "ref"));
	
КонецФункции
