﻿
Процедура ПередЗаписью(Отказ)
	
	Если Не ЭтоГруппа Тогда
		
		Если Не ЗначениеЗаполнено(Кластер) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "Кластер";
			Сообщение.Текст = "Не заполнен кластер.";
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ОбменНаправление) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "ОбменНаправление";
			Сообщение.Текст = "Направление обмена должно быть заполнено.";
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
		
		Если ОбменНаправление = Перечисления.КафкаНаправленияОбмена.Выгрузка
		И КлючСердес <> Перечисления.КафкаСердес.Null
		И КлючСердес <> Перечисления.КафкаСердес.ДвоичныеДанные
		И КлючСердес <> Перечисления.КафкаСердес.Строка
		И КлючСердес <> Перечисления.КафкаСердес.СтрокаAvro
		И КлючСердес <> Перечисления.КафкаСердес.СтруктураAvro
		И КлючСердес <> Перечисления.КафкаСердес.СтруктураJson
		И КлючСердес <> Перечисления.КафкаСердес.СоответствиеJson
		И КлючСердес <> Перечисления.КафкаСердес.Xml Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "КлючСердес";
			Сообщение.Текст = "Тип ключа не заполнен или заполнен некорректно.";
			Сообщение.Сообщить();
		КонецЕсли;
		
		Если ОбменНаправление = Перечисления.КафкаНаправленияОбмена.Выгрузка
		И ЗначениеСердес <> Перечисления.КафкаСердес.Null
		И ЗначениеСердес <> Перечисления.КафкаСердес.ДвоичныеДанные
		И ЗначениеСердес <> Перечисления.КафкаСердес.Строка
		И ЗначениеСердес <> Перечисления.КафкаСердес.СтрокаAvro
		И ЗначениеСердес <> Перечисления.КафкаСердес.СтруктураAvro
		И ЗначениеСердес <> Перечисления.КафкаСердес.СтруктураJson
		И ЗначениеСердес <> Перечисления.КафкаСердес.СоответствиеJson
		И ЗначениеСердес <> Перечисления.КафкаСердес.Xml Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "ЗначениеСердес";
			Сообщение.Текст = "Тип значения не заполнен или заполнен некорректно.";
			Сообщение.Сообщить();
		КонецЕсли;
		
		Если ОбменНаправление = Перечисления.КафкаНаправленияОбмена.Загрузка
		И КлючСердес <> Перечисления.КафкаСердес.Игнорировать
		И КлючСердес <> Перечисления.КафкаСердес.Null
		И КлючСердес <> Перечисления.КафкаСердес.ДвоичныеДанные
		И КлючСердес <> Перечисления.КафкаСердес.Строка
		И КлючСердес <> Перечисления.КафкаСердес.СтрокаAvro
		И КлючСердес <> Перечисления.КафкаСердес.СтруктураAvro
		И КлючСердес <> Перечисления.КафкаСердес.СтруктураJson
		И КлючСердес <> Перечисления.КафкаСердес.СоответствиеJson
		И КлючСердес <> Перечисления.КафкаСердес.Xml Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "КлючСердес";
			Сообщение.Текст = "Тип ключа не заполнен или заполнен некорректно.";
			Сообщение.Сообщить();
		КонецЕсли;
		
		Если ОбменНаправление = Перечисления.КафкаНаправленияОбмена.Загрузка
		И ЗначениеСердес <> Перечисления.КафкаСердес.Игнорировать
		И ЗначениеСердес <> Перечисления.КафкаСердес.Null
		И ЗначениеСердес <> Перечисления.КафкаСердес.ДвоичныеДанные
		И ЗначениеСердес <> Перечисления.КафкаСердес.Строка
		И ЗначениеСердес <> Перечисления.КафкаСердес.СтрокаAvro
		И ЗначениеСердес <> Перечисления.КафкаСердес.СтруктураAvro
		И ЗначениеСердес <> Перечисления.КафкаСердес.СтруктураJson
		И ЗначениеСердес <> Перечисления.КафкаСердес.СоответствиеJson
		И ЗначениеСердес <> Перечисления.КафкаСердес.Xml Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "ЗначениеСердес";
			Сообщение.Текст = "Тип значения не заполнен или заполнен некорректно.";
			Сообщение.Сообщить();
		КонецЕсли;
		
		Если ОбменНаправление = Перечисления.КафкаНаправленияОбмена.Загрузка
		И ПриемВРеальномВремени
		И ОбменДлительностьСеанса=0 Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "ОбменДлительностьСеанса";
			Сообщение.Текст = "В режиме ""Прием в реальном времени"" длительность сеанса обмена должна быть заполнена.";
			Сообщение.Сообщить();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Узел) Тогда
			Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА
			|ИЗ
			|	Справочник.КафкаШины КАК ШиныОбмена
			|ГДЕ
			|	ШиныОбмена.Узел = &Узел
			|	И ШиныОбмена.ОбменНаправление = &ОбменНаправление
			|	И ШиныОбмена.Ссылка <> &Ссылка");
			Запрос.УстановитьПараметр("Узел", Узел);
			Запрос.УстановитьПараметр("ОбменНаправление", ОбменНаправление);
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Если Не Запрос.Выполнить().Пустой() Тогда
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Поле = "Узел";
				Сообщение.Текст = "В справочнике уже присутствуют шины с данным узлом.";
				Сообщение.Сообщить();
			КонецЕсли;
		КонецЕсли;
		
		Тема = СокрЛП(Тема);
		Тема = НРег(Тема);
		
		Если Тема <> "" Тогда
			
			ТемаДлина = СтрДлина(Тема);
			
			Для НомерСимвола = 1 По ТемаДлина Цикл
				КодСимвола = КодСимвола(Тема, НомерСимвола);
				Если (КодСимвола>=48 И КодСимвола<=57) // цифры
				//ИЛИ (КодСимвола>=65 И КодСимвола<=90) // заглавные латинские буквы
				ИЛИ (КодСимвола>=97 И КодСимвола<=122) // строчные латинские буквы
				ИЛИ (КодСимвола = 42) // *
				ИЛИ (КодСимвола = 45) // дефис
				ИЛИ (КодСимвола = 46) // точка
				ИЛИ (КодСимвола = 95) // нижнее подчеркивание
				Тогда Иначе
					Отказ = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.УстановитьДанные(ЭтотОбъект);
					Сообщение.Поле = "Тема";
					Сообщение.Текст = "В имени темы разрешены только строчные латинские буквы, цифры, ""-"", ""_"", ""*"" (только в конце).";
					Сообщение.Сообщить();
				КонецЕсли;
			КонецЦикла;
			
			КодСимвола = КодСимвола(Тема);
			Если (КодСимвола>=97 И КодСимвола<=122) Тогда // строчные латинские буквы
			Иначе
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Поле = "Тема";
				Сообщение.Текст = "Имя темы должно начинаться с латинской буквы.";
				Сообщение.Сообщить();
			КонецЕсли;
			
			ПозицияЗвезды = СтрНайти(Тема, "*");
			Если ПозицияЗвезды>0 И ПозицияЗвезды<>ТемаДлина Тогда
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Поле = "Тема";
				Сообщение.Текст = "Символ ""*"" в имени темы разрешен только в самом конце.";
				Сообщение.Сообщить();
			КонецЕсли;
			
			Если ОбменНаправление = Перечисления.КафкаНаправленияОбмена.Загрузка И Не ПустаяСтрока(Тема) Тогда
				Запрос = Новый Запрос(
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ИСТИНА
				|ИЗ
				|	Справочник.КафкаШины КАК ШиныОбмена
				|ГДЕ
				|	ШиныОбмена.Тема = &Тема
				|	И ШиныОбмена.ОбменНаправление = &ОбменНаправление
				|	И ШиныОбмена.Ссылка <> &Ссылка");
				Запрос.УстановитьПараметр("Тема", Тема);
				Запрос.УстановитьПараметр("ОбменНаправление", ОбменНаправление);
				Запрос.УстановитьПараметр("Ссылка", Ссылка);
				Если Не Запрос.Выполнить().Пустой() Тогда
					Отказ = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.УстановитьДанные(ЭтотОбъект);
					Сообщение.Поле = "Тема";
					Сообщение.Текст = "В справочнике уже присутствуют шины с данной темой.";
					Сообщение.Сообщить();
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		ПриемПроцедура = СокрЛП(ПриемПроцедура);
		
		Если ОбменНаправление = Перечисления.КафкаНаправленияОбмена.Загрузка
		И (ПриемПроцедура = "" Или СтрНайти(ПриемПроцедура, " ") > 0 Или СтрНайти(ПриемПроцедура, "(") > 0 Или СтрНайти(ПриемПроцедура, ")") > 0) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "ПриемПроцедура";
			Сообщение.Текст = "Имя процедуры загрузки данных не заполнено или заполнено некорректно.";
			Сообщение.Сообщить();
		КонецЕсли;
		
		Если ОбменКоличествоПотоков=0 Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "ОбменКоличествоПотоков";
			Сообщение.Текст = "Не заполнено количество потоков.";
			Сообщение.Сообщить();
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		Если ОбменПоРасписанию Тогда
			
			_ОбменРасписание = ОбменРасписание.Получить();
			Если _ОбменРасписание = Неопределено Тогда
				_ОбменРасписание = Справочники.КафкаШины.ОбменРасписаниеПоУмолчанию();
				ОбменРасписание = Новый ХранилищеЗначения(_ОбменРасписание);
			КонецЕсли;
			
			ОбменРасписаниеПредставление = Строка(_ОбменРасписание);
			
			Если _ОбменРасписание.ПериодПовтораВТечениеДня <> 0 И _ОбменРасписание.ПериодПовтораВТечениеДня/2 < ОбменРасписаниеРазброс Тогда
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Поле = "ОбменРасписаниеРазброс";
				Сообщение.Текст = "Разброс расписания обмена не должен быть больше половины интервала повтора в течение дня.";
				Сообщение.Сообщить();
			КонецЕсли;
			
		Иначе
			ОбменРасписаниеПредставление = "";
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого С Из КафкаКонфигурация Цикл
			С.Параметр = СокрЛП(НРег(С.Параметр));
		КонецЦикла;
		
	КонецЕсли;
			
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
		
	Если Не ЭтоГруппа Тогда
	
		КафкаСервер.ОбновитьРегламентныеЗадания(Ссылка, ПометкаУдаления);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если Не ЭтоГруппа Тогда
	
		КафкаСервер.ОбновитьРегламентныеЗадания(Ссылка, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьЗначенияПоУмолчанию() Экспорт
	
	Если Не ЭтоГруппа Тогда
		
		Кластер = Справочники.КафкаКластеры.ПоУмолчанию;
		
		Мета = Метаданные();
		КлючСердес = Мета.Реквизиты.КлючСердес.ЗначениеЗаполнения;
		ЗначениеСердес = Мета.Реквизиты.ЗначениеСердес.ЗначениеЗаполнения;
		ОбменКоличествоПотоков = Мета.Реквизиты.ОбменКоличествоПотоков.ЗначениеЗаполнения;
		ОтправкаБлокироватьТаблицуРегистрации = Мета.Реквизиты.ОтправкаБлокироватьТаблицуРегистрации.ЗначениеЗаполнения;
		ОбменДлительностьСеанса = Мета.Реквизиты.ОбменДлительностьСеанса.ЗначениеЗаполнения;
		ПриемТаймаутОжидания = Мета.Реквизиты.ПриемТаймаутОжидания.ЗначениеЗаполнения;
		КлиентТаймаут = Мета.Реквизиты.КлиентТаймаут.ЗначениеЗаполнения;
		
		_ОбменРасписание = Справочники.КафкаШины.ОбменРасписаниеПоУмолчанию();
		ОбменРасписание = Новый ХранилищеЗначения(_ОбменРасписание);
		ОбменРасписаниеПредставление = Строка(_ОбменРасписание);
	
	КонецЕсли;
	
КонецПроцедуры