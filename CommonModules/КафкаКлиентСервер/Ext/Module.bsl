﻿
Функция ВерсияПодсистемы() Экспорт
	
	Возврат "2.0.7";
	
КонецФункции

Процедура СообщитьПользователю(Текст) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.Сообщить();
	
КонецПроцедуры

Функция КорневаяИнформацияОбОшибке(ИнформацияОбОшибке) Экспорт
	
	Результат = ИнформацияОбОшибке;
	Пока Результат.Причина <> Неопределено Цикл
		Результат = Результат.Причина;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#Область НейтральнаяСериализацияXML

#Если Не ВебКлиент Тогда

Функция СериализоватьXML(Значение, ОтступИлиЗаписьXML=Ложь) Экспорт
		
    ТипПараметра = ТипЗнч(ОтступИлиЗаписьXML);
	
	Если ТипПараметра = Тип("Булево") Тогда
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.Отступ = ОтступИлиЗаписьXML;
		ЗаписьXML.УстановитьСтроку();
	ИначеЕсли ТипПараметра = Тип("ЗаписьXML") Тогда
		ЗаписьXML = ОтступИлиЗаписьXML;
	Иначе
		ВызватьИсключение "Недопустимое значение параметра.";
	КонецЕсли;
	
#Если Клиент Тогда
	Типы = ТипыДляСериализацииXML();
#Иначе		
	Типы = КафкаПовтИсп.ТипыДляСериализацииXML();
#КонецЕсли
	
	ЗаписатьЗначениеXML(ЗаписьXML, Значение, Типы);
	
	Возврат ЗаписьXML.Закрыть();
	
КонецФункции
Процедура ЗаписатьЗначениеXML(ЗаписьXML, Значение, Типы)

	ТипЗнч = ТипЗнч(Значение);
	Если Типы.Соответствие.Получить(ТипЗнч) <> Неопределено Тогда
	    ЗаписатьСоответствиеXML(ЗаписьXML, Значение, Типы);
	ИначеЕсли Типы.Массив.Получить(ТипЗнч) <> Неопределено Тогда
	    ЗаписатьМассивXML(ЗаписьXML, Значение, Типы);
	Иначе
		ЗаписатьXML(ЗаписьXML, Значение);
	КонецЕсли;
	
КонецПроцедуры
Процедура ЗаписатьСоответствиеXML(ЗаписьXML, Соответствие, Типы)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("m");
	
	Для Каждого КлючЗначение Из Соответствие Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("v");
		ЗаписьXML.ЗаписатьАтрибут("k", XMLСтрока(КлючЗначение.Ключ));
		ЗаписатьЗначениеXML(ЗаписьXML, КлючЗначение.Значение, Типы);
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры	
Процедура ЗаписатьМассивXML(ЗаписьXML, Массив, Типы)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("a");
	
	Для Каждого Элемент Из Массив Цикл
		ЗаписатьЗначениеXML(ЗаписьXML, Элемент, Типы);
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры	

Функция ДесериализоватьXML(СтрокаИлиЧтениеXML, КакСоответствие=Ложь) Экспорт
	
    ТипПараметра = ТипЗнч(СтрокаИлиЧтениеXML);
	Если ТипПараметра = Тип("Строка") Тогда
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(СтрокаИлиЧтениеXML);
	ИначеЕсли ТипПараметра = Тип("ЧтениеXML") Тогда
		ЧтениеXML = СтрокаИлиЧтениеXML;
	Иначе
		ВызватьИсключение "Недопустимое значение параметра.";
	КонецЕсли;
	
	ЧтениеXML.Прочитать();
	Результат = ПрочитатьЗначениеXML(ЧтениеXML, КакСоответствие);
	
	ЧтениеXML.Закрыть();
	
	Возврат Результат;
	
КонецФункции
Функция ПрочитатьЗначениеXML(ЧтениеXML, КакСоответствие)
	
	Если ЧтениеXML.Имя = "m" Тогда
		Значение = ПрочитатьСоответствиеXML(ЧтениеXML, КакСоответствие);
	ИначеЕсли ЧтениеXML.Имя = "a" Тогда
		Значение = ПрочитатьМассивXML(ЧтениеXML, КакСоответствие);
	Иначе
		Значение = ПрочитатьXML(ЧтениеXML);
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции
Функция ПрочитатьСоответствиеXML(ЧтениеXML, КакСоответствие)
	
	Если КакСоответствие Тогда
		Результат = Новый Соответствие;
	Иначе
		Результат = Новый Структура;
	КонецЕсли;
	
	ЧтениеXML.Прочитать(); //потребим начало соответствия
	
	Пока ЧтениеXML.ТипУзла <> ТипУзлаXML.КонецЭлемента Цикл
		Ключ = ЧтениеXML.ПолучитьАтрибут(0);
		ЧтениеXML.Прочитать(); // потребим начало элемента значения
		Значение = ПрочитатьЗначениеXML(ЧтениеXML, КакСоответствие);
		ЧтениеXML.Прочитать(); // потребим конец элемента значения
		Результат.Вставить(Ключ, Значение);
	КонецЦикла;
	
	ЧтениеXML.Прочитать(); // потребим конец соответствия
		
	Возврат Результат;
	
КонецФункции
Функция ПрочитатьМассивXML(ЧтениеXML, КакСоответствие)
	
	Результат = Новый Массив;
	
	ЧтениеXML.Прочитать(); //потребим начало массива
	
	Пока ЧтениеXML.ТипУзла <> ТипУзлаXML.КонецЭлемента Цикл
		Значение = ПрочитатьЗначениеXML(ЧтениеXML, КакСоответствие);
		Результат.Добавить(Значение);
	КонецЦикла;
		
	ЧтениеXML.Прочитать(); // потребим конец массива
	
	Возврат Результат;
	
КонецФункции

Функция ТипыДляСериализацииXML() Экспорт
	
	ТипыСоответствие = Новый Соответствие;
	ТипыСоответствие.Вставить(Тип("Структура"), Истина);
	ТипыСоответствие.Вставить(Тип("ФиксированнаяСтруктура"), Истина);
	ТипыСоответствие.Вставить(Тип("Соответствие"), Истина);
	ТипыСоответствие.Вставить(Тип("ФиксированноеСоответствие"), Истина);
	
	ТипыМассив = Новый Соответствие;
	ТипыМассив.Вставить(Тип("Массив"), Истина);
	ТипыМассив.Вставить(Тип("ФиксированныйМассив"), Истина);
	
	Возврат Новый Структура("Соответствие, Массив",	ТипыСоответствие, ТипыМассив);
	
КонецФункции

#КонецЕсли

#КонецОбласти
