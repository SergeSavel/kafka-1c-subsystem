///////////////////////////////////////////////////////////////////////////////
// Низкоуровневый API интеграции Apache Kafka и 1C:Предприятие через
// REST-прокси.
// Версия 2.
// Автор: Сергей Савельев.
// Исходники REST-прокси: https://github.com/SergeSavel/kafka-rest-proxy-dotnet
///////////////////////////////////////////////////////////////////////////////

Перем Соединение;
Перем ПараметрыЗаписиJSON;

Процедура Инициализировать(Знач АдресПрокси=Неопределено, Пользователь=Неопределено, Пароль=Неопределено, Таймаут=65) Экспорт
		
	Если АдресПрокси=Неопределено Или ПустаяСтрока(АдресПрокси) Тогда
		_Сервер = "localhost";
		_Порт = "8080";
	Иначе
		ПозДвоеточие = Найти(АдресПрокси, ":");
		Если ПозДвоеточие = 0 Тогда
			_Сервер = АдресПрокси;
			_Порт = "";
		Иначе
			_Сервер = Лев(АдресПрокси, ПозДвоеточие-1);
			_Порт = Сред(АдресПрокси, ПозДвоеточие+1);
		КонецЕсли;
	КонецЕсли;
		
	Если ПустаяСтрока(_Порт) Тогда	
		Соединение = Новый HTTPСоединение(_Сервер, , Пользователь, Пароль, , Таймаут);
	Иначе
		Соединение = Новый HTTPСоединение(_Сервер, Число(_Порт), Пользователь, Пароль, , Таймаут);
	КонецЕсли;
	
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет);
		
КонецПроцедуры

#Область Администрирование

Функция GetMetadata(Знач Timeout=Неопределено) Экспорт
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = GetMetadata_(Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция GetMetadata_(Timeout)
	
	HttpЗапрос = Новый HTTPЗапрос("admin?timeout="+Формат(Timeout, "ЧН=0; ЧГ=0"));
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция GetTopicsMetadata(Знач Timeout=Неопределено) Экспорт
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = GetTopicsMetadata_(Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция GetTopicsMetadata_(Timeout)
	
	HttpЗапрос = Новый HTTPЗапрос("admin/topics?timeout="+Формат(Timeout, "ЧН=0; ЧГ=0"));
		
	Ответ = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(Ответ);
	
КонецФункции	

Функция GetTopicMetadata(Topic, Знач Timeout=Неопределено) Экспорт
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = GetTopicMetadata_(Topic, Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция GetTopicMetadata_(Topic, Timeout)
	
	HttpЗапрос = Новый HTTPЗапрос("admin/topics/"+Topic+"?timeout="+Формат(Timeout, "ЧН=0; ЧГ=0"));
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция GetTopicConfig(Topic, Знач Timeout=Неопределено) Экспорт
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = GetTopicConfig_(Topic, Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет, Истина);
	
КонецФункции
Функция GetTopicConfig_(Topic, Timeout)
	
	HttpЗапрос = Новый HTTPЗапрос("admin/topics/"+Topic+"/config?timeout="+Формат(Timeout, "ЧН=0; ЧГ=0"));
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция GetBrokersMetadata(Знач Timeout=Неопределено) Экспорт
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = GetBrokersMetadata_(Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция GetBrokersMetadata_(Timeout)
	
	HttpЗапрос = Новый HTTPЗапрос("admin/brokers?timeout="+Формат(Timeout, "ЧН=0; ЧГ=0"));
		
	Ответ = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(Ответ);
	
КонецФункции	

Функция GetBrokerMetadata(BrokerId, Знач Timeout=Неопределено) Экспорт
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = GetBrokerMetadata_(BrokerId, Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция GetBrokerMetadata_(BrokerId, Timeout)
	
	HttpЗапрос = Новый HTTPЗапрос("admin/brokers/"+Формат(BrokerId, "ЧН=0; ЧГ=0")+"?timeout="+Формат(Timeout, "ЧН=0; ЧГ=0"));
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция GetBrokerConfig(BrokerId, Знач Timeout=Неопределено) Экспорт
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = GetBrokerConfig_(BrokerId, Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет, Истина);
	
КонецФункции
Функция GetBrokerConfig_(BrokerId, Timeout)
	
	HttpЗапрос = Новый HTTPЗапрос("admin/brokers/"+Формат(BrokerId, "ЧН=0; ЧГ=0")+"/config?timeout="+Формат(Timeout, "ЧН=0; ЧГ=0"));
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция CreateTopic(Topic, NumPartitions=Неопределено, ReplicationFactor=Неопределено, Config=Неопределено, Знач Timeout=Неопределено) Экспорт
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = CreateTopic_(Topic, NumPartitions, ReplicationFactor, Config, Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция CreateTopic_(Topic, NumPartitions, ReplicationFactor, Config, Timeout)
	
	Тело = Новый Структура;
	Тело.Вставить("Name", Topic);
	Если NumPartitions <> Неопределено Тогда
		Тело.Вставить("NumPartitions", NumPartitions);
	КонецЕсли;
	Если ReplicationFactor <> Неопределено Тогда
		Тело.Вставить("ReplicationFactor", ReplicationFactor);
	КонецЕсли;
	Если Config <> Неопределено Тогда
		Тело.Вставить("Config", Config);
	КонецЕсли;
	
	HttpЗапрос = Новый HTTPЗапрос("admin/topics?timeout="+Формат(Timeout, "ЧН=0; ЧГ=0"));
	
	ЗаписатьJSONвHttpЗапрос(HttpЗапрос, Тело);
	
	HttpОтвет = Соединение.ОтправитьДляОбработки(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

#КонецОбласти

#Область Отправка

Функция Produce(Topic, Partition=Неопределено, Value, Key=Неопределено, Headers=Неопределено, ValueSchema=Неопределено, KeySchema=Неопределено) Экспорт
		
	HttpОтвет = Produce_(Topic, Partition, Value, Key, Headers, ValueSchema, KeySchema);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
//Функция ProduceGeneric(Topic, Partition=Неопределено, Value, ValueType, Key=Неопределено, KeyType=Неопределено, Headers=Неопределено) Экспорт
//	
//	Если Key <> Неопределено Тогда
//		Если KeyType = "String" Тогда
//			KeyString = Key;
//		ИначеЕсли KeyType = "AvroAsXml" Тогда
//			KeyString = КафкаКлиентСервер.СериализоватьXML(Key);
//		Иначе
//			ВызватьИсключение "Некорректное значение параметра ""KeyType"": " + KeyType;
//		КонецЕсли;
//	КонецЕсли;
//	
//	Если Value <> Неопределено Тогда
//		Если ValueType = "AvroAsXml" Тогда
//			ValueString = КафкаКлиентСервер.СериализоватьXML(Value);
//		Иначе
//			ВызватьИсключение "Некорректное значение параметра ""ValueType"": " + ValueType;
//		КонецЕсли;
//	КонецЕсли;
//	
//	HttpОтвет = Produce_(Topic, Partition, ValueString, ValueType, KeyString, KeyType, Headers);
//	
//	Возврат ПрочитатьТелоОтвета(HttpОтвет);
//	
//КонецФункции
Функция Produce_(Topic, Partition, ValueString, KeyString, Headers, ValueSchema, KeySchema)
		
	Body = Новый Структура;
	Если Headers <> Неопределено Тогда
		Body.Вставить("Headers", Headers);
	КонецЕсли;
	Если ТипКлюча <> "" Тогда
		Body.Вставить("KeyType", ТипКлюча);
	КонецЕсли;
	Если KeySchema <> Неопределено Тогда
		Body.Вставить("KeySchema", KeySchema);
	КонецЕсли;
	Если KeyString <> Неопределено Тогда
		Body.Вставить("Key", KeyString);
	КонецЕсли;
	Если ТипЗначения <> "" Тогда
		Body.Вставить("ValueType", ТипЗначения);
	КонецЕсли;
	Если ValueSchema <> Неопределено Тогда
		Body.Вставить("ValueSchema", ValueSchema);
	КонецЕсли;
	Body.Вставить("Value", ValueString);
	
	HttpЗапрос = Новый HTTPЗапрос("producer/produce?topic="+Topic);
	
	Если Partition <> Неопределено Тогда
		HttpЗапрос.АдресРесурса = HttpЗапрос.АдресРесурса + "&partition="+Формат(Partition, "ЧН=0; ЧГ=0");
	КонецЕсли;
	
	ЗаписатьJSONвHttpЗапрос(HttpЗапрос, Body);

	HttpОтвет = Соединение.ОтправитьДляОбработки(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

#КонецОбласти

#Область Получение

Функция CreateConsumer(Знач ExpirationTimeout=Неопределено, Config=Неопределено) Экспорт
	
	Если ExpirationTimeout = Неопределено Тогда
		ExpirationTimeout = 60000;
	КонецЕсли;
	
	HttpОтвет = CreateConsumer_(ExpirationTimeout, Config);
	
	Consumer = ПрочитатьТелоОтвета(HttpОтвет);
	
	Если Consumer = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Возврат Consumer;
	
КонецФункции
Функция CreateConsumer_(ExpirationTimeout, Config)
	
	Body = Новый Структура;
	Body.Вставить("ExpirationTimeoutMs", ExpirationTimeout);
	Если Config<>Неопределено Тогда
		Body.Вставить("Config", Config);
	КонецЕсли;
	Если ТипКлюча <> "" Тогда
		Body.Вставить("KeyType", ТипКлюча);
	КонецЕсли;
	Если ТипЗначения <> "" Тогда
		Body.Вставить("ValueType", ТипЗначения);
	КонецЕсли;
	
	HttpЗапрос = Новый HTTPЗапрос("consumers");
		
	ЗаписатьJSONвHttpЗапрос(HttpЗапрос, Body);

	HttpОтвет = Соединение.ОтправитьДляОбработки(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

Функция ReleaseConsumer(ConsumerId) Экспорт
	
	// Если уже была попытка удалить получателя, вторую попытку не производим.
	
	Если ConsumerId = Null Тогда
		Возврат Истина;
	КонецЕсли;
	ConsumerId_ = ConsumerId;
	ConsumerId = Null;
	
	КодОтвета_ = КодОтвета;
	ОписаниеОшибки_ = ОписаниеОшибки;
	
	HttpОтвет = ReleaseConsumer_(ConsumerId_);
	
	// ???
	Если КодОтвета_<200 Или КодОтвета_>299 Тогда
		КодОтвета = КодОтвета_;
		ОписаниеОшибки = ОписаниеОшибки_;
	КонецЕсли;
	
	Возврат (HttpОтвет<>Неопределено);
	
КонецФункции
Функция ReleaseConsumer_(ConsumerId)
	
	HttpЗапрос = Новый HTTPЗапрос("consumers/"+ConsumerId);
		
	HttpОтвет = Соединение.Удалить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

Функция GetConsumer(ConsumerId) Экспорт
	
	Если Не ЗначениеЗаполнено(ConsumerId) Тогда
		ВызватьИсключение "Не задан Id получателя. Возможно, получатель уже был удвлен.";
	КонецЕсли;
	
	HttpОтвет = GetConsumer_(ConsumerId);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция GetConsumer_(ConsumerId)
	
	HttpЗапрос = Новый HTTPЗапрос("consumers/"+ConsumerId);
		
	Ответ = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(Ответ);
	
КонецФункции	

Функция GetConsumerAssignment(ConsumerId) Экспорт
	
	Если Не ЗначениеЗаполнено(ConsumerId) Тогда
		ВызватьИсключение "Не задан Id получателя. Возможно, получатель уже был удвлен.";
	КонецЕсли;
	
	HttpОтвет = GetConsumerAssignment_(ConsumerId);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция GetConsumerAssignment_(ConsumerId)
	
	HttpЗапрос = Новый HTTPЗапрос("consumers/"+ConsumerId+"/assignment");
		
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция AssignConsumer(ConsumerId, Partitions) Экспорт
	
	Если Не ЗначениеЗаполнено(ConsumerId) Тогда
		ВызватьИсключение "Не задан Id получателя. Возможно, получатель уже был удвлен.";
	КонецЕсли;
	
	HttpОтвет = AssignConsumer_(ConsumerId, Partitions);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция AssignConsumer_(ConsumerId, Partitions)
	
	Если ТипЗнч(Partitions) = Тип("Массив") Тогда
		МассивНазначение = Partitions;
	Иначе
		МассивНазначение = Новый Массив;
		Если Partitions <> Неопределено Тогда
			МассивНазначение.Добавить(Partitions);
		КонецЕсли;
	КонецЕсли;
	
	Body = Новый Структура;
	Body.Вставить("ConsumerId", ConsumerId);
	Body.Вставить("Partitions", МассивНазначение);
	
	//Body.Вставить("Partitions", Новый Массив);
	//Для Каждого ТемаРазделСмещение Из МассивНазначение Цикл
	//	
	//	Partition = Новый Структура;
	//	Body.Partitions.Добавить(Partition);
	//	
	//	Для Каждого КЗ Из ТемаРазделСмещение Цикл
	//		Если КЗ.Ключ = "Тема" Тогда
	//			Partition.Вставить("Topic", КЗ.Значение)
	//		ИначеЕсли КЗ.Ключ = "Раздел" Тогда
	//			Partition.Вставить("Partition", КЗ.Значение);
	//		ИначеЕсли КЗ.Ключ = "Смещение" Тогда
	//			Partition.Вставить("Offset", Формат(КЗ.Значение, "ЧН=0; ЧГ=0"));
	//		КонецЕсли;
	//	КонецЦикла;
	//	Для Каждого КЗ Из ТемаРазделСмещение Цикл
	//		Если КЗ.Ключ = "Топик" Тогда
	//			Partition.Вставить("Topic", КЗ.Значение)
	//		ИначеЕсли КЗ.Ключ = "Партиция" Тогда
	//			Partition.Вставить("Partition", КЗ.Значение);
	//		ИначеЕсли КЗ.Ключ = "Офсет" Тогда
	//			Partition.Вставить("Offset", Формат(КЗ.Значение, "ЧН=0; ЧГ=0"));
	//		КонецЕсли;
	//	КонецЦикла;
	//	Для Каждого КЗ Из ТемаРазделСмещение Цикл
	//		Если КЗ.Ключ = "Topic" Тогда
	//			Partition.Вставить("Topic", КЗ.Значение)
	//		ИначеЕсли КЗ.Ключ = "Partition" Тогда
	//			Partition.Вставить("Partition", КЗ.Значение);
	//		ИначеЕсли КЗ.Ключ = "Offset" Тогда
	//			Partition.Вставить("Offset", Формат(КЗ.Значение, "ЧН=0; ЧГ=0"));
	//		КонецЕсли;
	//	КонецЦикла;
	//	
	//КонецЦикла;
		
	HttpЗапрос = Новый HTTPЗапрос("consumers/"+ConsumerId+"/assignment");
		
	ЗаписатьJSONвHttpЗапрос(HttpЗапрос, Body);

	HttpОтвет = Соединение.ОтправитьДляОбработки(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

Функция GetPartitionOffsets(ConsumerId, Topic, Partition, Знач Timeout=Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ConsumerId) Тогда
		ВызватьИсключение "Не задан Id получателя. Возможно, получатель уже был удвлен.";
	КонецЕсли;
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = GetPartitionOffsets_(ConsumerId, Topic, Partition, Timeout);
		
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция GetPartitionOffsets_(ConsumerId, Topic, Partition, Timeout)
	
	HttpЗапрос = Новый HTTPЗапрос("consumers/"+ConsumerId+"/offsets?topic="+Topic+"&partition="+Формат(Partition, "ЧН=0; ЧГ=0"));
	
	Если Timeout <> Неопределено Тогда
		HttpЗапрос.АдресРесурса = HttpЗапрос.АдресРесурса + "&timeout="+Формат(Timeout, "ЧН=0; ЧГ=0");
	КонецЕсли;
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция Consume(ConsumerId, Timeout=Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ConsumerId) Тогда
		ВызватьИсключение "Не задан Id получателя. Возможно, получатель уже был удвлен.";
	КонецЕсли;
	
	HttpОтвет = Consume_(ConsumerId, Timeout);
	
	СоответствиеРезультат = ПрочитатьТелоОтвета(HttpОтвет, Истина);
	
	Если СоответствиеРезультат=Неопределено Или СоответствиеРезультат=Null Тогда
		Возврат СоответствиеРезультат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Для Каждого КЗ Из СоответствиеРезультат Цикл
		Результат.Вставить(КЗ.Ключ, КЗ.Значение);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
Функция Consume_(ConsumerId, Timeout)
		
	HttpЗапрос = Новый HTTPЗапрос("consumers/"+ConsumerId+"/consume");
	
	ПараметрыЗапроса = "";
	Если Timeout <> Неопределено Тогда
		ПараметрыЗапроса = ПараметрыЗапроса + ?(ПараметрыЗапроса="", "?", "&") + "timeout="+Формат(Timeout, "ЧН=0; ЧГ=0");
	КонецЕсли;
	
	HttpЗапрос.АдресРесурса = HttpЗапрос.АдресРесурса + ПараметрыЗапроса;
		
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция ПолучитьСрезПоследнихСообщений(Тема) Экспорт
	
	TopicMetadata = GetTopicMetadata(Тема);
	Если TopicMetadata = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Если TopicMetadata.Partitions.Количество() = 0 Тогда
		Возврат Новый Соответствие;
	КонецЕсли;
		
	Consumer = CreateConsumer();
	Если Consumer = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Попытка
		
		Результат = ПолучитьСрезПоследнихСообщений_(TopicMetadata, Consumer);
		
		ReleaseConsumer(Consumer.Id);
		
	Исключение
		ReleaseConsumer(Consumer.Id);
		ВызватьИсключение;
	КонецПопытки;
			
	Возврат Результат;
	
КонецФункции
Функция ПолучитьСрезПоследнихСообщений_(TopicMetadata, Consumer)
	
	СмещенияТемы = Новый Соответствие;
	МассивНазначение = Новый Массив;
	Для Каждого PartitionMetadata Из TopicMetadata.Partitions Цикл
		
		PartitionOffsets = GetPartitionOffsets(Consumer.Id, TopicMetadata.Topic, PartitionMetadata.Partition, 10000);
		Если PartitionOffsets = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		СмещенияТемы.Вставить(PartitionMetadata.Partition, PartitionOffsets);
		МассивНазначение.Добавить(Новый Структура("Topic, Partition, Offset", TopicMetadata.Topic, PartitionMetadata.Partition, PartitionOffsets.Low));
		
	КонецЦикла;
			
	МассивНазначение = AssignConsumer(Consumer.Id, МассивНазначение);
	Если МассивНазначение = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Результат = Новый Соответствие;
	
	Пока Истина Цикл
		
		ConsumerMessage = Consume(Consumer.Id, 60000);
		Если ConsumerMessage = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Если ConsumerMessage = Null Тогда
			Прервать;
		КонецЕсли;
		
		Результат.Вставить(ConsumerMessage.Key, ConsumerMessage);
		
		PartitionOffsets = СмещенияТемы.Получить(ConsumerMessage.Partition);
		Если ConsumerMessage.Offset >= PartitionOffsets.High-1 Тогда
			СмещенияТемы.Удалить(ConsumerMessage.Partition);
		КонецЕсли;
		Если СмещенияТемы.Количество() = 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого PartitionMetadata Из TopicMetadata.Partitions Цикл
		
		PartitionOffsets = GetPartitionOffsets(Consumer.Id, TopicMetadata.Topic, PartitionMetadata.Partition, 10000);
		Если PartitionOffsets = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСмещенияТемы(Тема, Знач Таймаут=Неопределено) Экспорт
	
	Если Таймаут = Неопределено Тогда
		Таймаут = 10000;
	КонецЕсли;
	
	TopicMetadata = GetTopicMetadata(Тема);
	Если TopicMetadata = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Consumer = CreateConsumer(60000);
	Если Consumer = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Попытка
		Результат = ПолучитьСмещенияТемы_(TopicMetadata, Consumer, Таймаут);
		ReleaseConsumer(Consumer.Id);
	Исключение
		ReleaseConsumer(Consumer.Id);
		ВызватьИсключение;
	КонецПопытки;
				
	Возврат Результат;
	
КонецФункции
Функция ПолучитьСмещенияТемы_(TopicMetadata, Consumer, Таймаут)

	Результат = Новый Массив;
	
	Для Каждого PartitionMetadata Из TopicMetadata.Partitions Цикл
		
		PartitionOffsets = GetPartitionOffsets(Consumer.Id, TopicMetadata.Topic, PartitionMetadata.Partition, Таймаут);
		Если PartitionOffsets = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		PartitionOffsets.Удалить("Topic");
		
		Результат.Добавить(PartitionOffsets);
		
	КонецЦикла;
		
	Возврат Результат;
	
КонецФункции

Функция СпецСмещениеНачало()
	Возврат -2;
КонецФункции
Функция СпецСмещениеКонец()
	Возврат -1;
КонецФункции
Функция СпецСмещениеНеУстановлено()
	Возврат -1001;
КонецФункции
Функция СпецСмещениеЗаписано()
	Возврат -1000;
КонецФункции

#КонецОбласти

#Область Прокси

Функция GetProxyInfo() Экспорт
		
	HttpОтвет = GetProxyInfo_();
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция GetProxyInfo_()
	
	HttpЗапрос = Новый HTTPЗапрос("");
		
	Ответ = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(Ответ);
	
КонецФункции	

Функция GetProxyHealth() Экспорт
		
	HttpОтвет = GetProxyHealth_();
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция GetProxyHealth_()
	
	HttpЗапрос = Новый HTTPЗапрос("health");
		
	Ответ = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(Ответ);
	
КонецФункции	

#КонецОбласти

#Область ВспомогательныеФункции

Функция ПрочитатьТелоОтвета(HttpОтвет, КакСоответствие=Ложь)
	
	Если HttpОтвет = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	ContentLength = HttpОтвет.Заголовки.Получить("Content-Length");
	Если ContentLength = "0" Тогда
		Возврат NULL;
	КонецЕсли;
	
	ContentType = HttpОтвет.Заголовки.Получить("Content-Type");
	Если ContentType=Неопределено Или СтрНачинаетсяС(ContentType, "application/json") Тогда
		
		Поток = HttpОтвет.ПолучитьТелоКакПоток();
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.ОткрытьПоток(Поток);
		Результат = ПрочитатьJSON(ЧтениеJSON, КакСоответствие);
		ЧтениеJSON.Закрыть();
		
		Поток.Закрыть();
		
	ИначеЕсли СтрНачинаетсяС(ContentType, "text/plain") Тогда
		
		Результат = HttpОтвет.ПолучитьТелоКакСтроку();
		
	Иначе
		
		ВызватьИсключение "Неожиданный формат возвращенных данных: '"+ContentType+"'.";
		
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьJSONвHttpЗапрос(HttpЗапрос, Значение)
	
	HttpЗапрос.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
	
	Поток = HttpЗапрос.ПолучитьТелоКакПоток();
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.ОткрытьПоток(Поток, , , ПараметрыЗаписиJSON);
	ЗаписатьJSON(ЗаписьJSON, Значение);
	ЗаписьJSON.Закрыть();
	
	//Поток.Закрыть();
	
КонецПроцедуры

Функция ЗначениеКакJSON(Значение)
		
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	ЗаписатьJSON(ЗаписьJSON, Значение);
	Результат = ЗаписьJSON.Закрыть();
	
	Возврат Результат;
	
КонецФункции

Функция ПроверитьОтвет(HttpОтвет)
	
	КодОтвета = HttpОтвет.КодСостояния;
	
	Если HttpОтвет.КодСостояния<200 Или HttpОтвет.КодСостояния>299 Тогда
		ОписаниеОшибки = HttpОтвет.ПолучитьТелоКакСтроку();
		Возврат Неопределено;
	КонецЕсли;
	
	ОписаниеОшибки = Неопределено;
	Возврат HttpОтвет;
	
КонецФункции

#КонецОбласти
