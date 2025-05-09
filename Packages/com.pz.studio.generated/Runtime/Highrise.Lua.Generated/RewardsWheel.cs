/*

    Copyright (c) 2025 Pocketz World. All rights reserved.

    This is a generated file, do not edit!

    Generated by com.pz.studio
*/

#if UNITY_EDITOR

using System;
using System.Linq;
using UnityEngine;
using Highrise.Client;
using Highrise.Studio;
using Highrise.Lua;

namespace Highrise.Lua.Generated
{
    [AddComponentMenu("Lua/RewardsWheel")]
    [LuaRegisterType(0x63fd87dbe2f1731a, typeof(LuaBehaviour))]
    public class RewardsWheel : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "13503a8c40f25064da649219899cfd5b";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public System.Collections.Generic.List<UnityEngine.Texture> m_ItemIcons = default;
        [SerializeField] public UnityEngine.AnimationCurve m_SpinEasing = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), null),
                CreateSerializedProperty(_script.GetPropertyAt(1), null),
                CreateSerializedProperty(_script.GetPropertyAt(2), null),
                CreateSerializedProperty(_script.GetPropertyAt(3), null),
                CreateSerializedProperty(_script.GetPropertyAt(4), null),
                CreateSerializedProperty(_script.GetPropertyAt(5), null),
                CreateSerializedProperty(_script.GetPropertyAt(6), null),
                CreateSerializedProperty(_script.GetPropertyAt(7), null),
                CreateSerializedProperty(_script.GetPropertyAt(8), null),
                CreateSerializedProperty(_script.GetPropertyAt(9), m_ItemIcons),
                CreateSerializedProperty(_script.GetPropertyAt(10), m_SpinEasing),
            };
        }
    }
}

#endif
