create or replace function UDO_F_GENDER_BY_NAME
-- Определение пола по фамилии, имени и отчеству
(
  sFAMILYNAME     in varchar2,          -- Фамилия
  sFIRSTNAME      in varchar2,          -- Имя
  sLASTNAME       in varchar2           -- Отчество
)
return number                           -- Пол: 0 - не задан, 1 - мужской, 2 - женский
as
  nGENDER         number(1) := 0;       
  sTIE            PKG_STD.tSTRING;
  nMALES_COUNT    binary_integer;
  nFEMALES_COUNT  binary_integer;
begin
  -- Определение пола по отчеству
  if sLASTNAME is not null then
    sTIE := substr(lower(trim(sLASTNAME)), -2);
    if sTIE in ('ич', 'лы') then
      nGENDER := 1;
    elsif sTIE in ('на', 'зы', 'ва') then
      nGENDER := 2;
    end if;
  end if;
  
  -- Определение пола по фамилии
  if nGENDER = 0 and sFAMILYNAME is not null then
    sTIE := substr(lower(trim(sFAMILYNAME)), -2);
    if sTIE in ('ов', 'ев' ,'ин' ,'ын', 'ой', 'ий', 'ой') then
      nGENDER := 1;
    elsif sTIE in ('ва', 'на', 'ая', 'яя') then
      nGENDER := 2;
    end if;
  end if;

  -- Определение пола по имени
  if nGENDER = 0 and sFIRSTNAME is not null then
    sTIE := lower(trim(sFIRSTNAME));
    
    -- Определение пола по заданному здесь списку имён
    if sTIE in ('абрам', 'аверьян', 'авраам', 'агафон', 'адам', 'азар', 'акакий', 'аким', 'аксён', 'александр', 'алексей', 'альберт', 'анатолий', 'андрей', 'андрон', 'антип', 'антон', 'аполлон', 'аристарх', 'аркадий', 'арнольд', 'арсений', 'арсентий', 'артем', 'артём', 'артемий', 'артур', 'аскольд', 'афанасий', 'богдан', 'борис', 'борислав', 'бронислав', 'вадим', 'валентин', 'валерий', 'варлам', 'василий', 'венедикт', 'вениамин', 'веньямин', 'венцеслав', 'виктор', 'вилен', 'виталий', 'владилен', 'владимир', 'владислав', 'владлен', 'всеволод', 'всеслав', 'вячеслав', 'гавриил', 'геннадий', 'георгий', 'герман', 'глеб', 'григорий', 'давид', 'даниил', 'данил', 'данила', 'демьян', 'денис', 'димитрий', 'дмитрий', 'добрыня', 'евгений', 'евдоким', 'евсей', 'егор', 'емельян', 'еремей', 'ермолай', 'ерофей', 'ефим', 'захар', 'иван', 'игнат', 'игорь', 'илларион', 'иларион', 'илья', 'иосиф', 'казимир', 'касьян', 'кирилл', 'кондрат', 'константин', 'кузьма', 'лавр', 'лаврентий', 'лазарь', 'ларион', 'лев', 'леонард', 'леонид', 'лука', 'максим', 'марат', 'мартын', 'матвей', 'мефодий', 'мирон', 'михаил', 'моисей', 'назар', 'никита', 'николай', 'олег', 'осип', 'остап', 'павел', 'панкрат', 'пантелей', 'парамон', 'пётр', 'петр', 'платон', 'потап', 'прохор', 'роберт', 'ростислав', 'савва', 'савелий', 'семён', 'семен', 'сергей', 'сидор', 'спартак', 'тарас', 'терентий', 'тимофей', 'тимур', 'тихон', 'ульян', 'фёдор', 'федор', 'федот', 'феликс', 'фирс', 'фома', 'харитон', 'харлам', 'эдуард', 'эммануил', 'эраст', 'юлиан', 'юлий', 'юрий', 'яков', 'ян', 'ярослав') then
      nGENDER := 1;
    elsif sTIE in ('авдотья', 'аврора', 'агата', 'агния', 'агриппина', 'ада', 'аксинья', 'алевтина', 'александра', 'алёна', 'алена', 'алина', 'алиса', 'алла', 'альбина', 'амалия', 'анастасия', 'ангелина', 'анжела', 'анжелика', 'анна', 'антонина', 'анфиса', 'арина', 'белла', 'божена', 'валентина', 'валерия', 'ванда', 'варвара', 'василина', 'василиса', 'вера', 'вероника', 'виктория', 'виола', 'виолетта', 'вита', 'виталия', 'владислава', 'власта', 'галина', 'глафира', 'дарья', 'диана', 'дина', 'ева', 'евгения', 'евдокия', 'евлампия', 'екатерина', 'елена', 'елизавета', 'ефросиния', 'ефросинья', 'жанна', 'зиновия', 'злата', 'зоя', 'ивонна', 'изольда', 'илона', 'инга', 'инесса', 'инна', 'ирина', 'ия', 'капитолина', 'карина', 'каролина', 'кира', 'клавдия', 'клара', 'клеопатра', 'кристина', 'ксения', 'лада', 'лариса', 'лиана', 'лидия', 'лилия', 'лина', 'лия', 'лора', 'любава', 'любовь', 'людмила', 'майя', 'маргарита', 'марианна', 'мариетта', 'марина', 'мария', 'марья', 'марта', 'марфа', 'марьяна', 'матрёна', 'матрена', 'матрона', 'милена', 'милослава', 'мирослава', 'муза', 'надежда', 'настасия', 'настасья', 'наталия', 'наталья', 'нелли', 'ника', 'нина', 'нинель', 'нонна', 'оксана', 'олимпиада', 'ольга', 'пелагея', 'полина', 'прасковья', 'раиса', 'рената', 'римма', 'роза', 'роксана', 'руфь', 'сарра', 'светлана', 'серафима', 'снежана', 'софья', 'софия', 'стелла', 'степанида', 'стефания', 'таисия', 'таисья', 'тамара', 'татьяна', 'ульяна', 'устиния', 'устинья', 'фаина', 'фёкла', 'фекла', 'феодора', 'хаврония', 'христина', 'эвелина', 'эдита', 'элеонора', 'элла', 'эльвира', 'эмилия', 'эмма', 'юдифь', 'юлиана', 'юлия', 'ядвига', 'яна', 'ярослава') then
      nGENDER := 2;
    end if;

    -- Конкурентное определение пола по именам физических лиц, для которых задан пол с таким же именем
    -- Используется раздел Контрагенты системы Парус 8
    if nGENDER = 0 then
      -- Сколько мужчин с таким именем?
      select count(*)
        into nMALES_COUNT
        from AGNLIST A
       where A.AGNTYPE = 1 -- физическое лицо
         and A.SEX = 1     -- мужской пол
         and A.AGNFIRSTNAME = sFIRSTNAME; -- точное совпадение для использования индекса
    
      -- Сколько женщин с таким именем?
      select count(*)
        into nFEMALES_COUNT
        from AGNLIST A
       where A.AGNTYPE = 1 -- физическое лицо
         and A.SEX = 2     -- женский пол
         and A.AGNFIRSTNAME = sFIRSTNAME; -- точное совпадение для использования индекса
    
      -- Определяем пол по статистике распределения полов заданного имени
      if nMALES_COUNT > nFEMALES_COUNT then
        nGENDER := 1;
      elsif nMALES_COUNT < nFEMALES_COUNT then
        nGENDER := 2;
      
      -- Есть ещё идеи как определить пол по ФИО?
      else
        nGENDER := 0;
      end if;
    end if;
  end if;

  return nGENDER;
end;
