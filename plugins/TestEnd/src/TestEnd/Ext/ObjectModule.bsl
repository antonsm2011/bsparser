﻿
// Проверка комментариев в окончаниях инструкций

Перем Узлы;
Перем Исходник;
Перем Результат;
Перем Комментарии;
Перем УровеньОбласти;
Перем СтекОбластей;

Процедура Инициализировать(Парсер) Экспорт
	Узлы = Парсер.Узлы();
	Исходник = Парсер.Исходник();
	Результат = Новый Массив;
	УровеньОбласти = 0;
	СтекОбластей = Новый Соответствие;
КонецПроцедуры

Функция Закрыть() Экспорт
	Возврат СтрСоединить(Результат, Символы.ПС);
КонецФункции

Function Подписки() Экспорт
	Перем Подписки;
	Подписки = Новый Массив;
	Подписки.Add("ПосетитьМодуль");
	Подписки.Add("ПосетитьОбъявлениеМетода");
	Подписки.Add("ПосетитьИнструкциюПрепроцессора");
	Возврат Подписки;
EndFunction

Процедура ПосетитьМодуль(Модуль, Стек, Счетчики) Экспорт
	Комментарии = Модуль.Комментарии;
КонецПроцедуры

Процедура ПосетитьОбъявлениеМетода(ОбъявлениеМетода, Стек, Счетчики) Экспорт
	Комментарий = Комментарии[ОбъявлениеМетода.Место.НомерПоследнейСтроки];
	Если Комментарий <> Неопределено And СокрП(Комментарий) <> СтрШаблон(" %1%2", ОбъявлениеМетода.Сигнатура.Имя, "()") Тогда
		Результат.Add(СтрШаблон("Метод `%1()` имеет неправильный замыкающий комментарий в строке %2", ОбъявлениеМетода.Сигнатура.Имя, ОбъявлениеМетода.Место.НомерПоследнейСтроки));
	КонецЕсли;
КонецПроцедуры

Процедура ПосетитьИнструкциюПрепроцессора(ИнструкцияПрепроцессора, Stack, Counters) Экспорт
	Если ИнструкцияПрепроцессора.Тип = Узлы.ИнструкцияПрепроцессораОбласть Тогда
		УровеньОбласти = УровеньОбласти + 1;
		СтекОбластей[УровеньОбласти] = ИнструкцияПрепроцессора.Имя;
	ИначеЕсли ИнструкцияПрепроцессора.Тип = Узлы.ИнструкцияПрепроцессораКонецОбласти Тогда
		Комментарий = Комментарии[ИнструкцияПрепроцессора.Место.НомерПервойСтроки];
		ИмяОбласти = СтекОбластей[УровеньОбласти];
		Если Комментарий <> Неопределено And TrimR(Комментарий) <> СтрШаблон(" %1", ИмяОбласти) Тогда
			Результат.Add(СтрШаблон("Область `%1` имеет неправильный замыкающий комментарий в строке %2:", ИмяОбласти, ИнструкцияПрепроцессора.Место.НомерПервойСтроки));
			Результат.Add(СтрШаблон("%1`%2%3`", Chars.Tab, Mid(Исходник, ИнструкцияПрепроцессора.Место.Позиция, ИнструкцияПрепроцессора.Место.Длина), Комментарий));
		КонецЕсли;
		УровеньОбласти = УровеньОбласти - 1;
	КонецЕсли;
КонецПроцедуры
