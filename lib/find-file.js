'use babel';

import fs from 'fs';
import path from 'path';

export default (startdir, filename, parent) => {
  let result: string;
  const climb = startdir.split(path.sep);

  climb.some(() => {
    const dirpath = climb.join(path.sep);
    const target = path.join(dirpath, filename);

    if (fs.existsSync(target)) {
      result = parent ? dirpath : target;
      return true;
    }

    climb.splice(-1, 1);
    return false;
  });

  return result;
};
