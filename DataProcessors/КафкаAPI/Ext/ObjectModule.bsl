///////////////////////////////////////////////////////////////////////////////
// Низкоуровневый API интеграции Apache Kafka и 1C:Предприятие через
// REST-прокси.
// Версия 2.
// Автор: Сергей Савельев.
// Исходники REST-прокси: https://github.com/SergeSavel/kafka-rest-proxy-dotnet
///////////////////////////////////////////////////////////////////////////////

Перем Соединение;
Перем ПараметрыЗаписиJSON;

Процедура Инициализировать(Знач ПроксиАдрес=Неопределено, ПроксиПользователь=Неопределено, ПроксиПароль=Неопределено, ПроксиТаймаут=65) Экспорт
		
	Если ПроксиАдрес=Неопределено Или ПустаяСтрока(ПроксиАдрес) Тогда
		_Сервер = "localhost";
		_Порт = "8080";
	Иначе
		ПозДвоеточие = Найти(ПроксиАдрес, ":");
		Если ПозДвоеточие = 0 Тогда
			_Сервер = ПроксиАдрес;
			_Порт = "";
		Иначе
			_Сервер = Лев(ПроксиАдрес, ПозДвоеточие-1);
			_Порт = Сред(ПроксиАдрес, ПозДвоеточие+1);
		КонецЕсли;
	КонецЕсли;
		
	Если ПустаяСтрока(_Порт) Тогда	
		Соединение = Новый HTTPСоединение(_Сервер, , ПроксиПользователь, ПроксиПароль, , ПроксиТаймаут);
	Иначе
		Соединение = Новый HTTPСоединение(_Сервер, Число(_Порт), ПроксиПользователь, ПроксиПароль, , ПроксиТаймаут);
	КонецЕсли;
	
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет);
		
КонецПроцедуры

#Область Администрирование

Функция AdminCreate(Name, Config, Знач ExpirationTimeout=Неопределено) Экспорт
	
	Если ExpirationTimeout = Неопределено Тогда
		ExpirationTimeout = 60000;
	КонецЕсли;
	
	HttpОтвет = AdminCreate_(Name, Config, ExpirationTimeout);
	
	Admin = ПрочитатьТелоОтвета(HttpОтвет);
	
	//Если Admin = Неопределено Тогда
	//	Возврат Неопределено;
	//КонецЕсли;
		
	Возврат Admin;
	
КонецФункции
Функция AdminCreate_(Name, Config, ExpirationTimeout)
	
	Body = Новый Структура;
	Body.Вставить("Name", Name);
	Body.Вставить("Config", Config);
	Body.Вставить("ExpirationTimeoutMs", ExpirationTimeout);
	
	HttpЗапрос = Новый HTTPЗапрос("admin");
		
	ЗаписатьJSONвHttpЗапрос(HttpЗапрос, Body);

	HttpОтвет = Соединение.ОтправитьДляОбработки(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

Функция AdminRelease(AdminId, Token) Экспорт
	
	// Если уже была попытка удалить экземаляр, вторую попытку не производим.
	Если AdminId = Null Тогда
		Возврат Истина;
	КонецЕсли;
	AdminId_ = AdminId;
	AdminId = Null;
	
	КодОтвета_ = КодОтвета;
	ОписаниеОшибки_ = ОписаниеОшибки;
	
	HttpОтвет = AdminRelease_(AdminId_, Token);
	
	// ???
	Если КодОтвета_<200 Или КодОтвета_>299 Тогда
		КодОтвета = КодОтвета_;
		ОписаниеОшибки = ОписаниеОшибки_;
	КонецЕсли;
	
	Возврат (HttpОтвет<>Неопределено);
	
КонецФункции
Функция AdminRelease_(AdminId, Token)
	
	HttpЗапрос = Новый HTTPЗапрос("admin/"+AdminId+"?token="+Token);
		
	HttpОтвет = Соединение.Удалить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

Функция AdminGet(AdminId) Экспорт
	
	Если Не ЗначениеЗаполнено(AdminId) Тогда
		ВызватьИсключение "Не заполнен Id администратора. Возможно, экземпляр администратора уже был удален.";
	КонецЕсли;
	
	HttpОтвет = AdminGet_(AdminId);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция AdminGet_(AdminId)
	
	HttpЗапрос = Новый HTTPЗапрос("admin/"+AdminId);
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция AdminGetMetadata(AdminId, Token, Topic=Неопределено, Знач Timeout=Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(AdminId) Тогда
		ВызватьИсключение "Не заполнен Id администратора. Возможно, экземпляр администратора уже был удален.";
	КонецЕсли;
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = AdminGetMetadata_(AdminId, Token, Topic, Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция AdminGetMetadata_(AdminId, Token, Topic, Timeout)
	
	АдресРесурса = "admin/"+AdminId+"/metadata?token="+Token;
	Если Topic <> Неопределено Тогда
		АдресРесурса = АдресРесурса + "&topic="+Topic;
	КонецЕсли;
	АдресРесурса = АдресРесурса + "&timeout="+Формат(Timeout, "ЧН=0; ЧГ=0");
	
	HttpЗапрос = Новый HTTPЗапрос(АдресРесурса);
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция AdminGetTopicConfig(AdminId, Token, Topic, Знач Timeout=Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(AdminId) Тогда
		ВызватьИсключение "Не заполнен Id администратора. Возможно, экземпляр администратора уже был удален.";
	КонецЕсли;
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = AdminGetTopicConfig_(AdminId, Token, Topic, Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет, Истина);
	
КонецФункции
Функция AdminGetTopicConfig_(AdminId, Token, Topic, Timeout)
	
	АдресРесурса = "admin/"+AdminId+"/config?token="+Token+"&topic="+Topic+"&timeout="+Формат(Timeout, "ЧН=0; ЧГ=0");
	
	HttpЗапрос = Новый HTTPЗапрос(АдресРесурса);
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция AdminGetBrokerConfig(AdminId, Token, BrokerId, Знач Timeout=Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(AdminId) Тогда
		ВызватьИсключение "Не заполнен Id администратора. Возможно, экземпляр администратора уже был удален.";
	КонецЕсли;
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = AdminGetBrokerConfig_(AdminId, Token, BrokerId, Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет, Истина);
	
КонецФункции
Функция AdminGetBrokerConfig_(AdminId, Token, BrokerId, Timeout)
	
	АдресРесурса = "admin/"+AdminId+"/config?token="+Token+"&broker="+BrokerId+"&timeout="+Формат(Timeout, "ЧН=0; ЧГ=0");
	
	HttpЗапрос = Новый HTTPЗапрос(АдресРесурса);
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция AdminCreateTopic(AdminId, Token, Topic, NumPartitions=Неопределено, ReplicationFactor=Неопределено, Config=Неопределено, Знач Timeout=Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(AdminId) Тогда
		ВызватьИсключение "Не заполнен Id администратора. Возможно, экземпляр администратора уже был удален.";
	КонецЕсли;
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = AdminCreateTopic_(AdminId, Token, Topic, NumPartitions, ReplicationFactor, Config, Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция AdminCreateTopic_(AdminId, Token, Topic, NumPartitions, ReplicationFactor, Config, Timeout)
	
	Тело = Новый Структура;
	Тело.Вставить("Topic", Topic);
	Если NumPartitions <> Неопределено Тогда
		Тело.Вставить("NumPartitions", NumPartitions);
	КонецЕсли;
	Если ReplicationFactor <> Неопределено Тогда
		Тело.Вставить("ReplicationFactor", ReplicationFactor);
	КонецЕсли;
	Если Config <> Неопределено Тогда
		Тело.Вставить("Config", Config);
	КонецЕсли;
	
	АдресРесурса = "admin/"+AdminId+"/metadata?token="+Token+"&timeout="+Формат(Timeout, "ЧН=0; ЧГ=0");
	
	HttpЗапрос = Новый HTTPЗапрос(АдресРесурса);
	
	ЗаписатьJSONвHttpЗапрос(HttpЗапрос, Тело);
	
	HttpОтвет = Соединение.ОтправитьДляОбработки(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

#КонецОбласти

#Область Отправка

Функция ProducerCreate(Name, Config, Знач ExpirationTimeout=Неопределено) Экспорт
	
	Если ExpirationTimeout = Неопределено Тогда
		ExpirationTimeout = 60000;
	КонецЕсли;
	
	HttpОтвет = ProducerCreate_(Name, Config, ExpirationTimeout);
	
	Producer = ПрочитатьТелоОтвета(HttpОтвет);
	
	//Если Producer = Неопределено Тогда
	//	Возврат Неопределено;
	//КонецЕсли;
		
	Возврат Producer;
	
КонецФункции
Функция ProducerCreate_(Name, Config, ExpirationTimeout)
	
	Body = Новый Структура;
	Body.Вставить("Name", Name);
	Body.Вставить("Config", Config);
	Body.Вставить("ExpirationTimeoutMs", ExpirationTimeout);
	
	HttpЗапрос = Новый HTTPЗапрос("producer");
		
	ЗаписатьJSONвHttpЗапрос(HttpЗапрос, Body);

	HttpОтвет = Соединение.ОтправитьДляОбработки(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

Функция ProducerRelease(ProducerId, Token) Экспорт
	
	// Если уже была попытка удалить экземаляр, вторую попытку не производим.
	Если ProducerId = Null Тогда
		Возврат Истина;
	КонецЕсли;
	ProducerId_ = ProducerId;
	ProducerId = Null;
	
	КодОтвета_ = КодОтвета;
	ОписаниеОшибки_ = ОписаниеОшибки;
	
	HttpОтвет = ProducerRelease_(ProducerId_, Token);
	
	// ???
	Если КодОтвета_<200 Или КодОтвета_>299 Тогда
		КодОтвета = КодОтвета_;
		ОписаниеОшибки = ОписаниеОшибки_;
	КонецЕсли;
	
	Возврат (HttpОтвет<>Неопределено);
	
КонецФункции
Функция ProducerRelease_(ProducerId, Token)
	
	HttpЗапрос = Новый HTTPЗапрос("producer/"+ProducerId+"?token="+Token);
		
	HttpОтвет = Соединение.Удалить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

Функция ProducerGet(ProducerId) Экспорт
	
	Если Не ЗначениеЗаполнено(ProducerId) Тогда
		ВызватьИсключение "Не заполнен Id отправителя. Возможно, экземпляр отправителя уже был удален.";
	КонецЕсли;
	
	HttpОтвет = ProducerGet_(ProducerId);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция ProducerGet_(ProducerId)
	
	HttpЗапрос = Новый HTTPЗапрос("producer/"+ProducerId);
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция ProducerProduce(ProducerId, Token, Topic, Partition=Неопределено, Value, Key=Неопределено, Headers=Неопределено, ValueSchema=Неопределено, KeySchema=Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ProducerId) Тогда
		ВызватьИсключение "Не заполнен Id отправителя. Возможно, экземпляр отправителя уже был удален.";
	КонецЕсли;
	
	HttpОтвет = ProducerProduce_(ProducerId, Token, Topic, Partition, Value, Key, Headers, ValueSchema, KeySchema);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция ProducerProduce_(ProducerId, Token, Topic, Partition, ValueString, KeyString, Headers, ValueSchema, KeySchema)
		
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
	
	HttpЗапрос = Новый HTTPЗапрос("producer/"+ProducerId+"/produce?token="+Token+"&topic="+Topic);
	
	Если Partition <> Неопределено Тогда
		HttpЗапрос.АдресРесурса = HttpЗапрос.АдресРесурса + "&partition="+Формат(Partition, "ЧН=0; ЧГ=0");
	КонецЕсли;
	
	ЗаписатьJSONвHttpЗапрос(HttpЗапрос, Body);

	HttpОтвет = Соединение.ОтправитьДляОбработки(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

#КонецОбласти

#Область Получение

Функция ConsumerCreate(Name, Config, Знач ExpirationTimeout=Неопределено) Экспорт
	
	Если ExpirationTimeout = Неопределено Тогда
		ExpirationTimeout = 60000;
	КонецЕсли;
	
	HttpОтвет = ConsumerCreate_(Name, Config, ExpirationTimeout);
	
	Consumer = ПрочитатьТелоОтвета(HttpОтвет);
	
	//Если Consumer = Неопределено Тогда
	//	Возврат Неопределено;
	//КонецЕсли;
		
	Возврат Consumer;
	
КонецФункции
Функция ConsumerCreate_(Name, Config, ExpirationTimeout)
	
	Body = Новый Структура;
	Body.Вставить("Name", Name);
	Body.Вставить("Config", Config);
	Body.Вставить("ExpirationTimeoutMs", ExpirationTimeout);
	Если ЗначениеЗаполнено(ТипКлюча) Тогда
		Body.Вставить("KeyType", ТипКлюча);
	КонецЕсли;
	Если ЗначениеЗаполнено(ТипЗначения) Тогда
		Body.Вставить("ValueType", ТипЗначения);
	КонецЕсли;
	
	HttpЗапрос = Новый HTTPЗапрос("consumer");
		
	ЗаписатьJSONвHttpЗапрос(HttpЗапрос, Body);

	HttpОтвет = Соединение.ОтправитьДляОбработки(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

Функция ConsumerRelease(ConsumerId, Token) Экспорт
	
	// Если уже была попытка удалить экземаляр, вторую попытку не производим.
	Если ConsumerId = Null Тогда
		Возврат Истина;
	КонецЕсли;
	ConsumerId_ = ConsumerId;
	ConsumerId = Null;
	
	КодОтвета_ = КодОтвета;
	ОписаниеОшибки_ = ОписаниеОшибки;
	
	HttpОтвет = ConsumerRelease_(ConsumerId_, Token);
	
	// ???
	Если КодОтвета_<200 Или КодОтвета_>299 Тогда
		КодОтвета = КодОтвета_;
		ОписаниеОшибки = ОписаниеОшибки_;
	КонецЕсли;
	
	Возврат (HttpОтвет<>Неопределено);
	
КонецФункции
Функция ConsumerRelease_(ConsumerId, Token)
	
	HttpЗапрос = Новый HTTPЗапрос("consumer/"+ConsumerId+"?token="+Token);
		
	HttpОтвет = Соединение.Удалить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

Функция ConsumerGet(ConsumerId) Экспорт
	
	Если Не ЗначениеЗаполнено(ConsumerId) Тогда
		ВызватьИсключение "Не заполнен Id получателя. Возможно, экземпляр получателя уже был удален.";
	КонецЕсли;
	
	HttpОтвет = ConsumerGet_(ConsumerId);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция ConsumerGet_(ConsumerId)
	
	HttpЗапрос = Новый HTTPЗапрос("consumer/"+ConsumerId);
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция ConsumerGetAssignment(ConsumerId, Token) Экспорт
	
	Если Не ЗначениеЗаполнено(ConsumerId) Тогда
		ВызватьИсключение "Не задан Id получателя. Возможно, получатель уже был удален.";
	КонецЕсли;
	
	HttpОтвет = ConsumerGetAssignment_(ConsumerId, Token);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция ConsumerGetAssignment_(ConsumerId, Token)
	
	HttpЗапрос = Новый HTTPЗапрос("consumer/"+ConsumerId+"/assignment?token="+Token);
		
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция ConsumerAssign(ConsumerId, Token, Partitions) Экспорт
	
	Если Не ЗначениеЗаполнено(ConsumerId) Тогда
		ВызватьИсключение "Не задан Id получателя. Возможно, получатель уже был удален.";
	КонецЕсли;
	
	HttpОтвет = ConsumerAssign_(ConsumerId, Token, Partitions);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция ConsumerAssign_(ConsumerId, Token, Partitions)
	
	Если ТипЗнч(Partitions) = Тип("Массив") Тогда
		Body = Partitions;
	Иначе
		Body = Новый Массив;
		Если Partitions <> Неопределено Тогда
			Body.Добавить(Partitions);
		КонецЕсли;
	КонецЕсли;
		
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
		
	HttpЗапрос = Новый HTTPЗапрос("consumer/"+ConsumerId+"/assignment?token="+Token);
		
	ЗаписатьJSONвHttpЗапрос(HttpЗапрос, Body);

	HttpОтвет = Соединение.ОтправитьДляОбработки(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции

Функция ConsumerQueryPartitionOffsets(ConsumerId, Token, Topic, Partition, Знач Timeout=Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ConsumerId) Тогда
		ВызватьИсключение "Не задан Id получателя. Возможно, получатель уже был удален.";
	КонецЕсли;
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = ConsumerGetPartitionOffsets_(ConsumerId, Token, Topic, Partition, Timeout);
		
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция ConsumerGetPartitionOffsets_(ConsumerId, Token, Topic, Partition, Timeout)
	
	HttpЗапрос = Новый HTTPЗапрос("consumer/"+ConsumerId+"/offsets?token="+Token+"&topic="+Topic+"&partition="+Формат(Partition, "ЧН=0; ЧГ=0"));
	
	Если Timeout <> Неопределено Тогда
		HttpЗапрос.АдресРесурса = HttpЗапрос.АдресРесурса + "&timeout="+Формат(Timeout, "ЧН=0; ЧГ=0");
	КонецЕсли;
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция ConsumerConsume(ConsumerId, Token, Timeout=Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ConsumerId) Тогда
		ВызватьИсключение "Не задан Id получателя. Возможно, получатель уже был удален.";
	КонецЕсли;
	
	HttpОтвет = ConsumerConsume_(ConsumerId, Token, Timeout);
	
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
Функция ConsumerConsume_(ConsumerId, Token, Timeout)
		
	HttpЗапрос = Новый HTTPЗапрос("consumer/"+ConsumerId+"/consume?token="+Token);
	
	ПараметрыЗапроса = "";
	Если Timeout <> Неопределено Тогда
		ПараметрыЗапроса = ПараметрыЗапроса + "&timeout="+Формат(Timeout, "ЧН=0; ЧГ=0");
	КонецЕсли;
	
	HttpЗапрос.АдресРесурса = HttpЗапрос.АдресРесурса + ПараметрыЗапроса;
		
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция ConsumerGetMetadata(ConsumerId, Token, Topic=Неопределено, Знач Timeout=Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ConsumerId) Тогда
		ВызватьИсключение "Не задан Id получателя. Возможно, получатель уже был удален.";
	КонецЕсли;
	
	Если Timeout = Неопределено Тогда
		Timeout = 10000;
	КонецЕсли;
	
	HttpОтвет = ConsumerGetMetadata_(ConsumerId, Token, Topic, Timeout);
	
	Возврат ПрочитатьТелоОтвета(HttpОтвет);
	
КонецФункции
Функция ConsumerGetMetadata_(ConsumerId, Token, Topic, Timeout)
	
	АдресРесурса = "consumer/"+ConsumerId+"/metadata?token="+Token;
	Если Topic <> Неопределено Тогда
		АдресРесурса = АдресРесурса + "&topic="+Topic;
	КонецЕсли;
	АдресРесурса = АдресРесурса + "&timeout="+Формат(Timeout, "ЧН=0; ЧГ=0");
	
	HttpЗапрос = Новый HTTPЗапрос(АдресРесурса);
	
	HttpОтвет = Соединение.Получить(HttpЗапрос);
	
	Возврат ПроверитьОтвет(HttpОтвет);
	
КонецФункции	

Функция ПолучитьСрезПоследнихСообщений(ИмяОперации, Конфигурация, Тема) Экспорт
	
	Consumer = ConsumerCreate(ИмяОперации, Конфигурация);
	Если Consumer = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
					
	Попытка
		Результат = ПолучитьСрезПоследнихСообщений_(Consumer, Тема);
		ConsumerRelease(Consumer.Id, Consumer.Token);
	Исключение
		ConsumerRelease(Consumer.Id, Consumer.Token);
		ВызватьИсключение;
	КонецПопытки;
			
	Возврат Результат;
	
КонецФункции
Функция ПолучитьСрезПоследнихСообщений_(Consumer, Тема)
	
	Md = ConsumerGetMetadata(Consumer.Id, Consumer.Token, Тема);
	Если Md = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	TopicMd = Md.Topics[0];
	
	Если TopicMd.Partitions.Количество() = 0 Тогда
		Возврат Новый Соответствие;
	КонецЕсли;
	
	СмещенияТемы = Новый Соответствие;
	МассивНазначение = Новый Массив;
	Для Каждого PartitionMd Из TopicMd.Partitions Цикл
		
		PartitionOffsets = ConsumerQueryPartitionOffsets(Consumer.Id, Consumer.Token, TopicMd.Topic, PartitionMd.Partition);
		Если PartitionOffsets = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Если PartitionOffsets.Low <> PartitionOffsets.High Тогда
			СмещенияТемы.Вставить(PartitionMd.Partition, PartitionOffsets);
			МассивНазначение.Добавить(Новый Структура("Topic, Partition, Offset", TopicMd.Topic, PartitionMd.Partition, PartitionOffsets.Low));
		КонецЕсли;
		
	КонецЦикла;
			
	МассивНазначение = ConsumerAssign(Consumer.Id, Consumer.Token, МассивНазначение);
	Если МассивНазначение = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Результат = Новый Соответствие;
	
	Пока Истина Цикл
		
		ConsumerMessage = ConsumerConsume(Consumer.Id, Consumer.Token, 60000);
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
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСмещенияТемы(ИмяОперации, Конфигурация, Тема, Знач Таймаут=Неопределено) Экспорт
	
	Если Таймаут = Неопределено Тогда
		Таймаут = 10000;
	КонецЕсли;
	
	Consumer = ConsumerCreate(ИмяОперации, Конфигурация);
	Если Consumer = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
					
	Попытка
		Результат = ПолучитьСмещенияТемы_(Consumer, Тема, Таймаут);
		ConsumerRelease(Consumer.Id, Consumer.Token);
	Исключение
		ConsumerRelease(Consumer.Id, Consumer.Token);
		ВызватьИсключение;
	КонецПопытки;
				
	Возврат Результат;
	
КонецФункции
Функция ПолучитьСмещенияТемы_(Consumer, Тема, Таймаут)

	Md = ConsumerGetMetadata(Consumer.Id, Consumer.Token, Тема);
	Если Md = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	TopicMd = Md.Topics[0];
	
	Результат = Новый Массив;
	
	Для Каждого PartitionMd Из TopicMd.Partitions Цикл
		
		PartitionOffsets = ConsumerQueryPartitionOffsets(Consumer.Id, Consumer.Token, TopicMd.Topic, PartitionMd.Partition, Таймаут);
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
	
	Если HttpОтвет.КодСОстояния = 204 Тогда
		Возврат NULL;
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
		
	ИначеЕсли СтрНачинаетсяС(ContentType, "application/octet-stream") Тогда
		
		Результат = HttpОтвет.ПолучитьТелоКакДвоичныеДанные();
		
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
