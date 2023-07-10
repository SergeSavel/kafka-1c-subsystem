﻿
Процедура ПередЗаписью(Отказ)
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.КафкаКластеры");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	
	Если ДополнительныеСвойства.Свойство("НазначитьПоУмолчанию") И ДополнительныеСвойства.НазначитьПоУмолчанию=Истина Тогда
		
		ИмяПредопределенныхДанных = "ПоУмолчанию";
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Кластеры.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.КафкаКластеры КАК Кластеры
		|ГДЕ
		|	Кластеры.ИмяПредопределенныхДанных = &ИмяПредопределенныхДанных
		|	И Кластеры.Ссылка <> &Ссылка");
		Запрос.УстановитьПараметр("ИмяПредопределенныхДанных", ИмяПредопределенныхДанных);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			ПредТЗ = РезультатЗапроса.Выгрузить();
			Для Каждого ПредС Из ПредТЗ Цикл
				ПредОбъект = ПредС.Ссылка.ПолучитьОбъект();
				ПредОбъект.ИмяПредопределенныхДанных = "";
				ПредОбъект.Записать();
			КонецЦикла;
		КонецЕсли;
				
	КонецЕсли;
	
	Для Каждого С Из КафкаКонфигурацияОтправителя Цикл
		С.Параметр = СокрЛП(НРег(С.Параметр));
	КонецЦикла;
	
	Для Каждого С Из КафкаКонфигурацияПолучателя Цикл
		С.Параметр = СокрЛП(НРег(С.Параметр));
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ОбновитьРегламентноеЗаданиеМониторинг();
	
КонецПроцедуры

Процедура ОбновитьРегламентноеЗаданиеМониторинг()
	
	Удалить = (Не МониторингВключен Или ПустаяСтрока(МониторингZabbixКомандаZabbixSender));
	
	ЗаданиеМетаданные = Метаданные.РегламентныеЗадания.КафкаМониторинг;
		
	МассивЗаданий = Новый Массив;
	
	М = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", ЗаданиеМетаданные));
	Для Каждого Задание Из М Цикл
		Если Задание.Параметры=Неопределено Или Задание.Параметры.Количество()<>1 Или ТипЗнч(Задание.Параметры[0])<>Тип("СправочникСсылка.КафкаКластеры") Или Не ЗначениеЗаполнено(Задание.Параметры[0]) Тогда
			КафкаСервер.УдалитьРегламентноеЗадание(Задание);
		ИначеЕсли Задание.Параметры[0] = Ссылка Тогда
			МассивЗаданий.Добавить(Задание);
		КонецЕсли;
	КонецЦикла;
	
	Если Удалить Тогда
		
		Для Каждого Задание_ Из МассивЗаданий Цикл
			КафкаСервер.УдалитьРегламентноеЗадание(Задание_);
		КонецЦикла;
		
		Возврат;
		
	КонецЕсли;
	
	Задание = Неопределено;
	
	Если МассивЗаданий.Количество() > 0 Тогда
		Задание = МассивЗаданий.Получить(0);
		МассивЗаданий.Удалить(0);
	КонецЕсли;
	
	Для Каждого Задание_ Из МассивЗаданий Цикл
		КафкаСервер.УдалитьРегламентноеЗадание(Задание_);
	КонецЦикла;
	
	Если Задание = Неопределено Тогда
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(ЗаданиеМетаданные);
	КонецЕсли;
	
	ЗаданиеПараметры = Новый Массив;
	ЗаданиеПараметры.Добавить(Ссылка);
	
	Задание.Параметры = ЗаданиеПараметры;
	Задание.Ключ = ЗаданиеМетаданные.Ключ+"_"+Ссылка.УникальныйИдентификатор();
	Задание.Наименование = ЗаданиеМетаданные.Наименование+" ("+Наименование+")";
	Задание.Использование = Истина;
	Задание.ИмяПользователя = МониторингПользовательРЗ;
	
	Задание.Записать();
	
КонецПроцедуры
