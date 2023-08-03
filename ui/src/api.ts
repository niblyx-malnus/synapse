import Urbit from '@urbit/http-api';
import memoize from 'lodash/memoize';

const shipName = 'bud';
const shipCode = 'lathus-worsem-bortem-padmel';
const shipURI = 'http://localhost:8080';

export const api = {
  createApi: memoize(() => {
    const urb = new Urbit(shipURI, shipCode);
    urb.ship = shipName;
    urb.onError = (message: string) => console.log('onError: ', message);
    urb.onOpen = () => console.log('urbit onOpen');
    urb.onRetry = () => console.log('urbit onRetry');
    urb.connect();
    return urb;
  }),
  /**
   *  Scries
   */
  getTags: async () => {
    return api.createApi().scry({ app: 'synapse', path: '/tags' });
  },
  getClusters: async () => {
    return api.createApi().scry({ app: 'synapse', path: '/clusters' });
  },
  getSource: async () => {
    return api.createApi().scry({ app: 'synapse', path: '/source' });
  },
  getEchoes: async () => {
    return api.createApi().scry({ app: 'synapse', path: '/echoes' });
  },
  getLocks: async () => {
    return api.createApi().scry({ app: 'synapse', path: '/locks' });
  },
    vent: async (vnt: any) => {
    const result: any = await api.createApi().thread({
      inputMark: 'vent-package', // input to thread, contains poke
      outputMark: vnt.outputMark,
      threadName: 'venter',
      body: {
        dock: {
          ship: vnt.ship,
          dude: vnt.dude,
        },
        input: {
          desk: vnt.inputDesk,
          mark: vnt.inputMark, // mark of the poke itself
        },
        output: {
          desk: vnt.outputDesk,
          mark: vnt.outputMark,
        },
        body: vnt.body,
      },
      desk: 'synapse',
    });
    if (
      result !== null &&
      result.term &&
      result.tang &&
      Array.isArray(result.tang)
    ) {
      throw new Error(`\n${result.term}\n${result.tang.join('\n')}`);
    } else {
      return result;
    }
  },
  asyncCreateVent: async (body: any) => {
    return await api.vent({
      ship: shipName, // the ship to poke
      dude: 'synapse', // the agent to poke
      inputDesk: 'synapse', // where does the input mark live
      inputMark: 'synapse-async-create', // name of input mark
      outputDesk: 'synapse', // where does the output mark live
      outputMark: 'synapse-vent', // name of output mark
      body: body, // the actual poke content
    });
  },
  tagCommandVent: async (body: any) => {
    return await api.vent({
      ship: shipName, // the ship to poke
      dude: 'synapse', // the agent to poke
      inputDesk: 'synapse', // where does the input mark live
      inputMark: 'synapse-tag-command', // name of input mark
      outputDesk: 'synapse', // where does the output mark live
      outputMark: 'synapse-vent', // name of output mark
      body: body, // the actual poke content
    });
  },
  pinCommandVent: async (body: any) => {
    return await api.vent({
      ship: shipName, // the ship to poke
      dude: 'synapse', // the agent to poke
      inputDesk: 'synapse', // where does the input mark live
      inputMark: 'synapse-pin-command', // name of input mark
      outputDesk: 'synapse', // where does the output mark live
      outputMark: 'synapse-vent', // name of output mark
      body: body, // the actual poke content
    });
  },
  lockCommandVent: async (body: any) => {
    return await api.vent({
      ship: shipName, // the ship to poke
      dude: 'synapse', // the agent to poke
      inputDesk: 'synapse', // where does the input mark live
      inputMark: 'synapse-lock-command', // name of input mark
      outputDesk: 'synapse', // where does the output mark live
      outputMark: 'synapse-vent', // name of output mark
      body: body, // the actual poke content
    });
  },
  ventReadVent: async (body: any) => {
    return await api.vent({
      ship: shipName, // the ship to poke
      dude: 'synapse', // the agent to poke
      inputDesk: 'synapse', // where does the input mark live
      inputMark: 'synapse-vent-read', // name of input mark
      outputDesk: 'synapse', // where does the output mark live
      outputMark: 'synapse-vent', // name of output mark
      body: body, // the actual poke content
    });
  },
  /**
   * Vent reads
   */
  distBySubjs: async (list: { ship: string, 'tag-id': string }[]) => {
    return await api.ventReadVent({ 'dist-by-subjs': list });
  },
  distByShips: async (list: string[]) => {
    return await api.ventReadVent({ 'dist-by-ships': list });
  },
  distByTags: async (list: string[]) => {
    return await api.ventReadVent({ 'dist-by-tags': list });
  },
  aggrBySubjs: async (list: { ship: string, 'tag-id': string }[]) => {
    return await api.ventReadVent({ 'aggr-by-subjs': list });
  },
  aggrByShips: async (list: string[]) => {
    return await api.ventReadVent({ 'aggr-by-ships': list });
  },
  aggrByTags: async (list: string[]) => {
    return await api.ventReadVent({ 'aggr-by-tags': list });
  },
  /**
   * Async creates
   */
  tagAsyncCreate: async (name: string, description: string) => {
    return await api.asyncCreateVent({ tag: { name, description } });
  },
  pinAsyncCreate: async (ship: string, weight: number) => {
    return await api.asyncCreateVent({ pin: { ship, weight } });
  },
  /**
   * Pin related
   */
  pinUpdate: async (ship: string, pin: string, weight: number) => {
    const json = { p: { ship, pin }, q: { 'update-pin': weight } };
    return await api.pinCommandVent(json);
  },
  pinDelete: async (ship: string, pin: string) => {
    const json = { p: { ship, pin }, q: { 'delete-pin': null } };
    return await api.pinCommandVent(json);
  },
  putTag: async (ship: string, pin: string, tagId: string) => {
    const json = { p: { ship, pin }, q: { 'put-tag': tagId } };
    return await api.pinCommandVent(json);
  },
  delTag: async (ship: string, pin: string, tagId: string) => {
    const json = { p: { ship, pin }, q: { 'del-tag': tagId } };
    return await api.pinCommandVent(json);
  },
  /**
   * Tags related
   */
  tagUpdate: async (
    tagId: string,
    fields: {
      name?: string;
      description?: string;
    }
  ) => {
    const { name, description } = fields;
    const fieldsList = [
      typeof name === 'string' ? { title: name } : null,
      typeof description === 'string' ? { description: description } : null,
    ].filter(Boolean);
    const json = {
      p: tagId,
      q: { update: fieldsList },
    };
    return await api.tagCommandVent(json);
  },
  tagDelete: async (tagId: string) => {
    const json = { p: tagId, q: { delete: null } };
    return await api.tagCommandVent(json);
  },
  /**
   * Locks related
   */
  tagLockUpdate: async (agent: string, path: string) => {
    return await api.lockCommandVent({tag: { dude: agent, path }});
  },
  weightLockUpdate: async (agent: string, path: string) => {
    return await api.lockCommandVent({weight: { dude: agent, path }});
  },
  kickTagLocked: async () => {
    return await api.lockCommandVent({'kick-tag-locked': null})
  }
};