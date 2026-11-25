/**
 * react-native-change-icon HarmonyOS Example
 *
 * 覆盖库全部公开 API：changeIcon(iconName?) / resetIcon() / getIcon()。
 *
 * @format
 */

import React, {useCallback, useState} from 'react';
import type {PropsWithChildren} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import {changeIcon, resetIcon, getIcon} from 'react-native-change-icon';

const ICON_OPTIONS: ReadonlyArray<{id: string; label: string}> = [
  {id: 'Default', label: '默认'},
  {id: 'qixi', label: '七夕'},
  {id: 'spring_festival', label: '春节'},
];

function Card({title, children}: PropsWithChildren<{title: string}>): JSX.Element {
  return (
    <View style={styles.card}>
      <Text style={styles.cardTitle}>{title}</Text>
      {children}
    </View>
  );
}

function App(): JSX.Element {
  const [currentIcon, setCurrentIcon] = useState<string>('（未查询）');
  const [selectedIconId, setSelectedIconId] = useState<string>(ICON_OPTIONS[0].id);
  const [busy, setBusy] = useState<boolean>(false);

  const run = useCallback(async (api: string, fn: () => Promise<string>): Promise<void> => {
    if (busy) {
      return;
    }
    setBusy(true);
    try {
      const value: string = await fn();
      if (api === 'getIcon') {
        setCurrentIcon(value);
      }
    } catch {
      // 调用失败时保持当前展示。
    } finally {
      setBusy(false);
    }
  }, [busy]);

  const onGetIcon = useCallback((): void => {
    run('getIcon', getIcon);
  }, [run]);

  const onChangeIcon = useCallback((): void => {
    run('changeIcon', () => changeIcon(selectedIconId));
  }, [run, selectedIconId]);

  const onResetIcon = useCallback((): void => {
    run('resetIcon', resetIcon);
  }, [run]);

  return (
    <SafeAreaView style={styles.root}>
      <StatusBar barStyle="dark-content" />
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <Text style={styles.header}>react-native-change-icon</Text>
        <Text style={styles.subHeader}>HarmonyOS Example · AppGallery Kit 图标管理服务</Text>

        <Card title={'当前图标：' + currentIcon}>
          <TouchableOpacity
            style={[styles.button, styles.primaryButton, busy && styles.buttonDisabled]}
            disabled={busy}
            onPress={onGetIcon}>
            <Text style={styles.buttonText}>查询当前图标 getIcon()</Text>
          </TouchableOpacity>
        </Card>

        <Card title="切换图标 changeIcon(iconName)">
          {ICON_OPTIONS.map(option => {
            const selected = option.id === selectedIconId;
            return (
              <TouchableOpacity
                key={option.id}
                style={[styles.iconOption, selected && styles.iconOptionSelected]}
                disabled={busy}
                onPress={() => setSelectedIconId(option.id)}>
                <Text style={[styles.iconOptionLabel, selected && styles.iconOptionLabelSelected]}>
                  {option.label}
                </Text>
                <Text style={[styles.iconOptionId, selected && styles.iconOptionLabelSelected]}>{option.id}</Text>
              </TouchableOpacity>
            );
          })}
          <TouchableOpacity
            style={[styles.button, styles.primaryButton, busy && styles.buttonDisabled]}
            disabled={busy}
            onPress={onChangeIcon}>
            <Text style={styles.buttonText}>{'切换到 ' + selectedIconId}</Text>
          </TouchableOpacity>
          <Text style={styles.hint}>可选 Default、qixi、spring_festival。选择 Default 时恢复默认图标。</Text>
        </Card>

        <Card title="恢复默认图标 resetIcon()">
          <TouchableOpacity
            style={[styles.button, styles.secondaryButton, busy && styles.buttonDisabled]}
            disabled={busy}
            onPress={onResetIcon}>
            <Text style={styles.secondaryButtonText}>resetIcon()</Text>
          </TouchableOpacity>
        </Card>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: '#f2f3f5',
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 40,
  },
  header: {
    fontSize: 22,
    fontWeight: '700',
    color: '#1a1a1a',
  },
  subHeader: {
    fontSize: 13,
    color: '#666666',
    marginTop: 4,
    marginBottom: 12,
  },
  card: {
    backgroundColor: '#ffffff',
    borderRadius: 8,
    padding: 14,
    marginBottom: 12,
  },
  cardTitle: {
    fontSize: 15,
    fontWeight: '600',
    color: '#1a1a1a',
    marginBottom: 10,
  },
  button: {
    borderRadius: 6,
    paddingVertical: 10,
    alignItems: 'center',
    marginTop: 6,
  },
  primaryButton: {
    backgroundColor: '#0a5fca',
  },
  secondaryButton: {
    backgroundColor: '#e6f0fb',
    borderWidth: 1,
    borderColor: '#0a5fca',
  },
  buttonDisabled: {
    opacity: 0.5,
  },
  buttonText: {
    color: '#ffffff',
    fontSize: 14,
    fontWeight: '600',
  },
  secondaryButtonText: {
    color: '#0a5fca',
    fontSize: 14,
    fontWeight: '600',
  },
  iconOption: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderWidth: 1,
    borderColor: '#d9d9d9',
    borderRadius: 6,
    paddingHorizontal: 12,
    paddingVertical: 10,
    marginBottom: 8,
    backgroundColor: '#fafafa',
  },
  iconOptionSelected: {
    borderColor: '#0a5fca',
    backgroundColor: '#e6f0fb',
  },
  iconOptionLabel: {
    fontSize: 15,
    fontWeight: '600',
    color: '#1a1a1a',
  },
  iconOptionLabelSelected: {
    color: '#0a5fca',
  },
  iconOptionId: {
    fontSize: 13,
    color: '#666666',
  },
  hint: {
    fontSize: 12,
    color: '#8a8a8a',
    marginTop: 8,
    lineHeight: 17,
  },
});

export default App;
