import dayjs from 'dayjs';

function formatDate(date) {
  // 获取当前日期（去掉时间部分）
  const today = dayjs().startOf('day');
  // 将给定日期转换为 dayjs 对象，并去掉时间部分
  const targetDate = dayjs(date).startOf('day');

  // 判断是否是今天
  if (targetDate.isSame(today)) {
    // 如果是今天，返回时间部分 HH:mm:ss
    return dayjs(date).format('HH:mm:ss');
  } else {
    // 如果不是今天，返回完整日期时间 YYYY-MM-DD HH:mm:ss
    return dayjs(date).format('YYYY-MM-DD HH:mm:ss');
  }
}

export default formatDate;