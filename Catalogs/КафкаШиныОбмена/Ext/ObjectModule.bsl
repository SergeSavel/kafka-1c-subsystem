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
		
		Если Вид<>"Источник" И Вид<>"Приемник" Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "Вид";
			Сообщение.Текст = "Вид шины не заполнен или заполнен некорректно.";
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
				
		Если Вид="Источник" И ПриемВРеальномВремени И ПриемДлительность=0 Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "ПриемДлительность";
			Сообщение.Текст = "В режиме ""Прием в реальном времени"" длительность сеанса приема должна быть заполнена.";
			Сообщение.Сообщить();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Узел) Тогда
			Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА
			|ИЗ
			|	Справочник.КафкаШиныОбмена КАК ШиныОбмена
			|ГДЕ
			|	ШиныОбмена.Узел = &Узел
			|	И ШиныОбмена.Вид = &Вид
			|	И ШиныОбмена.Ссылка <> &Ссылка");
			Запрос.УстановитьПараметр("Узел", Узел);
			Запрос.УстановитьПараметр("Вид", Вид);
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
				ИЛИ (КодСимвола = 45) // дефис
				//ИЛИ (КодСимвола = 95) // нижнее подчеркивание - нужно ли ?
				Тогда Иначе
					Отказ = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.УстановитьДанные(ЭтотОбъект);
					Сообщение.Поле = "Тема";
					Сообщение.Текст = "В имени темы разрешены только строчные латинские буквы, цифры и символ ""-"".";
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
			
			Если Не ПустаяСтрока(Тема) Тогда
				Запрос = Новый Запрос(
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ИСТИНА
				|ИЗ
				|	Справочник.КафкаШиныОбмена КАК ШиныОбмена
				|ГДЕ
				|	ШиныОбмена.Тема = &Тема
				|	И ШиныОбмена.Вид = &Вид
				|	И ШиныОбмена.Ссылка <> &Ссылка");
				Запрос.УстановитьПараметр("Тема", Тема);
				Запрос.УстановитьПараметр("Вид", Вид);
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
		
		Если Вид="Приемник" И ОтправкаПараллелизм=0 Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Поле = "ОтправкаПараллелизм";
			Сообщение.Текст = "Параллелизм отправки не должен быть равен нулю.";
			Сообщение.Сообщить();
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		Если ОбменПоРасписанию Тогда
			_ОбменРасписание = ОбменРасписание.Получить();
			Если ОбменРасписание = Неопределено Тогда
				_ОбменРасписание = Справочники.КафкаШиныОбмена.ОбменРасписаниеПоУмолчанию();
				ОбменРасписание = Новый ХранилищеЗначения(_ОбменРасписание);
			КонецЕсли;
			ОбменРасписаниеПредставление = Строка(_ОбменРасписание);
		Иначе
			ОбменРасписаниеПредставление = "";
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
		ОтправкаПараллелизм = Мета.Реквизиты.ОтправкаПараллелизм.ЗначениеЗаполнения;
		ОтправкаБлокироватьТаблицуРегистрации = Мета.Реквизиты.ОтправкаБлокироватьТаблицуРегистрации.ЗначениеЗаполнения;
		ПриемДлительность = Мета.Реквизиты.ПриемДлительность.ЗначениеЗаполнения;
		ПриемТаймаутОжидания = Мета.Реквизиты.ПриемТаймаутОжидания.ЗначениеЗаполнения;
		КлиентТаймаут = Мета.Реквизиты.КлиентТаймаут.ЗначениеЗаполнения;
		
		_ОбменРасписание = Справочники.КафкаШиныОбмена.ОбменРасписаниеПоУмолчанию();
		ОбменРасписание = Новый ХранилищеЗначения(_ОбменРасписание);
		ОбменРасписаниеПредставление = Строка(_ОбменРасписание);
	
	КонецЕсли;
	
КонецПроцедуры