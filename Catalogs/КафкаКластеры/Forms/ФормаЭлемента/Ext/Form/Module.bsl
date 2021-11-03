﻿
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	КафкаПользовательПоУмолчанию = КафкаПереопределяемый.ПользовательПоУмолчанию();	
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("НазначитьПоУмолчанию") Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("НазначитьПоУмолчанию", ПараметрыЗаписи.НазначитьПоУмолчанию);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ОбновитьВидимостьДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоУмолчанию(Команда)
	
	Записать(Новый Структура("НазначитьПоУмолчанию", Истина));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьДоступность(Форма)
	
	Форма.Элементы.КафкаПользовательПоУмолчанию.Видимость = Не Форма.Объект.КафкаПользовательУстановлен;
	Форма.Элементы.КафкаПользователь.Видимость = Форма.Объект.КафкаПользовательУстановлен;
	
КонецПроцедуры

&НаКлиенте
Процедура КафкаПользовательУстановленПриИзменении(Элемент)
	
	ОбновитьВидимостьДоступность(ЭтаФорма);
	
КонецПроцедуры
